#! /bin/bash -x


#01. 获取时间，取前一天00:00:00到当前时间的数据
currentDate=`date +%Y-%m-%d`
currentTime=`date +%H:%M:%S`
ip_addr="${1}"
port="$2"
db_name="${4}"
table_name="${5}"
split_by="${6}"
mr_count="${7}"
columns="${8}"
dwd_hive_table_name="ods_${db_name}__${table_name}"
log_path="/tmp/sqoopload"

if [ ! -d "$log_path" ]; then
	mkdir -p $log_path
fi

if [ "$#" -ne "10"  ]; then

echo "useage: qlserver2Hive  datelabel shop_id ip_addr db_name table_name  split_by columns"
echo "$@"
exit 1
fi



if [ "$select_condition" != "no" ];then

    query_state="select ${columns}   from ${table_name}  where  ${condtion}  and \$CONDITIONS"

else
    query_state="select ${columns}   from ${table_name}  where \$CONDITIONS"

fi

echo ${query_state}


hive_db="ods_tmp"
hive_table="${db_name}__${table_name}"
target_dir="/user/sqoop/${hive_db}/${hive_table}/datelabel=${datelabel}/shop_id=${shop_id}"
mapreduce_job_name="${db_name}__${table_name}_${shop_id}_${ip_addr}"
class_name="${db_name}__${table_name}"
#清理数据
hadoop fs -test -e ${target_dir}

if [ $? -eq 0  ]; then
    hadoop fs -rm ${target_dir}/part*
fi

#创建目录和分区
hive -e "Alter table ${hive_db}.${hive_table} add if not exists partition (datelabel=${datelabel},shop_id='${shop_id}') location 'datelabel=${datelabel}/shop_id=${shop_id}'";
#02. 根据时间将数据导入到临时表
#--driver com.microsoft.jdbc.sqlserver.SQLServerDriver \
sqoop import \
-Dhadoop.security.credential.provider.path=jceks://hdfs/user/passwd/10.10.135.83/dql/mysql.pwd.83.usvr_analysis.jceks  \
--connect  "jdbc:mysql://${ip_addr}:${port}/${db_name}?connectTimeout=600000&socketTimeout=600000&useUnicode=true&characterEncoding=utf-8&tinyInt1isBit=false&autoReconnect=true&failOverReadOnly=false" \
--username usvr_analysis \
--password-alias mysql.83.usvr_analysis.pwd.alias;
--hive-database ${hive_db} \
--hive-table ${hive_table} \
--split-by ${split_by} \
--null-string '\\N'  \
--null-non-string '\\N' \
--hive-drop-import-delims  \
-m ${mr_count} --append  \
--hive-overwrite  \
--mapreduce-job-name  ${mapreduce_job_name} \
--outdir  ${log_path} \
--bindir  ${log_path} \
--class-name ${class_name} \
--fields-terminated-by '|' \
--lines-terminated-by "\n" \
--target-dir /user/sqoop/ods/${dwd_hive_table_name} \
--query "${query_state}"
