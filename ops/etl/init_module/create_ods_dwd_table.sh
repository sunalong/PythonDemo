#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
#----------------------首次导入-----------------------------------------
mysql_host="$1"
echo before split mysql_host:$mysql_host
mysql_host_arr=(${mysql_host//,/ })
mysql_host=${mysql_host_arr[0]}
mysql_host_2=${mysql_host_arr[1]}

mysql_port="$2"
mysql_db_name="$3"
mysql_table_name="$4"
primary_key="$5"
order_field="$6"
mr_count="$7"
username="$8"
ods_hive_table_name="ods_${mysql_db_name}__${mysql_table_name}"
dwd_hive_table_name="dwd_${mysql_db_name}__${mysql_table_name}"
split_id=`echo "$primary_key" | awk  -F "," '{print $1}'`

echo "mysql_host=$mysql_host"
echo "mysql_port=$mysql_port"
echo "mysql_db_name=$mysql_db_name"
echo "mysql_table_name=$mysql_table_name"
echo "primary_key=$primary_key"
echo "order_field=$order_field"
echo "mr_count=$mr_count"
echo "ods_hive_table_name=$ods_hive_table_name"
echo "split_id=$split_id"
echo "username=$username"

if [ "$#" -lt "7" ]; then

 echo "Error11: expect 2 param"
 echo "useage: sh create_ods_dwd_table.sh  10.9.164.106 3310  member_center  t_member_address  id  last_updated_at 2 "
 exit 11;
fi

if [ "${mysql_host_2}" == "" ];then
    sqoop_mysql_db_name=${mysql_db_name}
else
    sqoop_mysql_db_name=${mysql_db_name}_16
fi

if [ "${username}" == "usvr_analysis" ];then
    jceks="jceks://hdfs/user/passwd/10.10.31.110/dql/mysql.pwd.110.usvr_analysis.jceks"
    password_alias="mysql.110.usvr_analysis.pwd.alias"
else
    jceks="jceks://hdfs/user/passwd/0.0.0.0/dql/mysql.pwd.0000.bi_sync.jceks"
    password_alias="mysql.0000.bi_sync.pwd.alias"
fi

#01.复制MySQL的表结构到Hive--sqoop命令行-----
hive -e "drop table if exists ods.${ods_hive_table_name}"
sqoop create-hive-table  \
-Dhadoop.security.credential.provider.path=${jceks} \
--connect "jdbc:mysql://${mysql_host}:${mysql_port}/${sqoop_mysql_db_name}?connectTimeout=600000&socketTimeout=600000&useUnicode=true&characterEncoding=utf-8&tinyInt1isBit=false&autoReconnect=true&failOverReadOnly=false" \
--username ${username} \
--password-alias ${password_alias} \
--table ${mysql_table_name} \
--hive-database ods \
--hive-table ${ods_hive_table_name} \
--fields-terminated-by '\0005'  \
--lines-terminated-by "\n";

if  [ "$?" -ne "0" ]; then
   echo "Error22: create hive table ${mysql_table_name}"
   exit 12;
fi


#02.创建Hive表对应的目录


hadoop fs -test -e /user/sqoop/ods/${ods_hive_table_name}

if [ "$?" -eq "0" ] ;then  
    echo "Dir is exist! coutinue!"  
else 
	hadoop fs -mkdir /user/sqoop/ods/${ods_hive_table_name}

	if  [ $? -ne 0 ]; then
   		echo "Error13: create hdfs ${ods_hive_table_name}"
   		exit 13;
	fi
fi  



#03.修改表Hive表对应的目录:  HIVE终端执行
hive -e "use ods; ALTER TABLE ${ods_hive_table_name} SET LOCATION 'hdfs://Ucluster/user/sqoop/ods/${ods_hive_table_name}';"
if  [ $? -ne 0 ]; then
   echo "Error14:  ALTER TABLE  ${mysql_table_name}"
   exit 14;
fi


#04.转换为外部表 HIVE终端执行
hive -e "use ods;ALTER TABLE ${ods_hive_table_name} SET TBLPROPERTIES ('EXTERNAL'='TRUE');"

if  [ "$?" -ne "0" ]; then
   echo "Error15:  ALTER TABLE  ${ods_hive_table_name}"
   exit 15;
fi

#05. 增量脚本配置

/bin/bash ${curr_dir}/incremental.sh "$@"

#05.2 增量脚本配置 ods_view
/bin/bash ${curr_dir}/incremental_view.sh "$@"




#05. 创建dwd层表
sql_file="${dwd_hive_table_name}.sql"

if [ -f "${curr_dir}/$sql_file" ]; then
    rm -f ${curr_dir}/$sql_file
fi

echo "drop table IF EXISTS dwd.${dwd_hive_table_name} ;" >> ${curr_dir}/${sql_file}
echo "create table IF NOT EXISTS dwd.${dwd_hive_table_name} (" >> ${curr_dir}/${sql_file}
hive -e "use ods; desc ${ods_hive_table_name}" | awk '{print ","$1"  "$2  }' >> ${curr_dir}/${sql_file}
echo ") stored as orc;" >> ${curr_dir}/${sql_file}
sed -i "3s:,::g" ${curr_dir}/${sql_file}
#Todo:Test
#sed -i "2s:,::g" ${curr_dir}/${sql_file}

#hive -f ${curr_dir}/${sql_file}


