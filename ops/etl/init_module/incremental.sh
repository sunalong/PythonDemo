#! /bin/bash
#
#
#配置增量调度脚本
#
#
#

declare -r curr_dir=$(cd `dirname $0`; pwd)

currentDate=`date +%Y-%m-%d`
currentTime=`date +%H%M%S`

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
tardir="${mysql_table_name}"

echo "mysql_host=$mysql_host"
echo "mysql_host_2=$mysql_host_2"
echo "mysql_port=$mysql_port"
echo "mysql_db_name=$mysql_db_name"
echo "mysql_table_name=$mysql_table_name"
echo "primary_key=$primary_key"
echo "order_field=$order_field"
echo "ods_hive_table_name=$ods_hive_table_name"
echo "split_id=$split_id"
echo "username=$username"


if [ "$#" -lt "7" ]; then

 echo "Error19: expect 7 param"
 echo "useage: /bin/bash xxxx.sh mysql_table_name ods_hive_table_name  split_id primary_key"
 exit 19;
fi


if [ "${username}" == "usvr_analysis" ];then
    jceks="jceks://hdfs/user/passwd/10.10.31.110/dql/mysql.pwd.110.usvr_analysis.jceks"
    password_alias="mysql.110.usvr_analysis.pwd.alias"
else
    jceks="jceks://hdfs/user/passwd/0.0.0.0/dql/mysql.pwd.0000.bi_sync.jceks"
    password_alias="mysql.0000.bi_sync.pwd.alias"
fi

echo "----------------------准备模板和元数据------------------------------"
hive_sql="use ods; desc ${ods_hive_table_name}"
deal_sql="awk '{print $1","}'  |  tr -d ["\n"]  | sed  's/,$//'"
columns=`hive -e "${hive_sql}" |awk '{print $1","}'  |  tr -d ["\n"]  | sed  's/,$//'`

if  [ "$?" -ne "0" ]; then
   echo "Error21: get columns error"
   exit 21;
fi

echo "columns=$columns"
if [ -d "${tardir}" ] ;then
    mv  ${curr_dir}/${tardir} ${curr_dir}/${tardir}_bak_${currentDate}-${currentTime}
fi

cp -rf ${curr_dir}/ods_module ${curr_dir}/${mysql_table_name}

if  [ "$?" -ne "0" ]; then
   echo "Error22: copy ${tardir} error"
   exit 22;
fi


echo "-----------------------模板替换为目标---------------------------------------"
cd ${curr_dir}/${tardir}

crontab_script="crontab_${ods_hive_table_name}.sh"
echo "${crontab_script}"
mv crontab_ods_module.sh ${crontab_script}



mapreduce_job_name="${mysql_db_name}.${mysql_table_name}"
log_path="/var/log/sqoopload"
class_name="${mysql_db_name}__${mysql_table_name}"
ods_hive_table_name="${ods_hive_table_name}"
query_state="select ${columns} from ${mysql_db_name}.${mysql_table_name} where"
everyday_crontab="${order_field} >= '\$beforeDay' and"

if [ "${mysql_host_2}" == "" ];then
    # 没有分库分表
    rm mysql2HiveTmp_16.sh
    rm mysql2HiveTmp_17.sh

    sed  -i   "s#__ip_addr__#${mysql_host}#g"                               mysql2HiveTmp.sh
    sed  -i   "s#__port__#${mysql_port}#g"                                  mysql2HiveTmp.sh
    sed  -i   "s#__db_name__#${mysql_db_name}#g"                            mysql2HiveTmp.sh
    sed  -i   "s#__hive_db__#ods#g"                                         mysql2HiveTmp.sh
    sed  -i   "s#__hive_table__#${ods_hive_table_name}#g"                   mysql2HiveTmp.sh
    sed  -i   "s#__split_by__#${split_id}#g"                                mysql2HiveTmp.sh
    sed  -i   "s#__mr_count__#${mr_count}#g"                                mysql2HiveTmp.sh
    sed  -i   "s#__mapreduce_job_name__#${mapreduce_job_name}#g"            mysql2HiveTmp.sh
    sed  -i   "s#__log_path__#${log_path}#g"                                mysql2HiveTmp.sh
    sed  -i   "s#__class_name__#${class_name}#g"                            mysql2HiveTmp.sh
    sed  -i   "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g"          mysql2HiveTmp.sh
    sed  -i   "s#__query_state__#${query_state}#g"                          mysql2HiveTmp.sh
    sed  -i   "s#__everyday_crontab__#${everyday_crontab}#g"                mysql2HiveTmp.sh
    sed  -i   "s#__ods_hive_table_name__#${ods_hive_table_name}#g"          mysql2HiveTmp.sh
    sed  -i   "s#__jceks__#${jceks}#g"                                      mysql2HiveTmp.sh
    sed  -i   "s#__username__#${username}#g"                                mysql2HiveTmp.sh
    sed  -i   "s#__password_alias__#${password_alias}#g"                    mysql2HiveTmp.sh

else
    # 有分库分表
    rm mysql2HiveTmp.sh
    query_state="select ${columns} from ${mysql_db_name}_\${i}.${mysql_table_name} where"

    sed  -i   "s#__ip_addr__#${mysql_host}#g"                               mysql2HiveTmp_16.sh
    sed  -i   "s#__port__#${mysql_port}#g"                                  mysql2HiveTmp_16.sh
    sed  -i   "s#__db_name__#${mysql_db_name}#g"                            mysql2HiveTmp_16.sh
    sed  -i   "s#__hive_db__#ods#g"                                         mysql2HiveTmp_16.sh
    sed  -i   "s#__hive_table__#${ods_hive_table_name}#g"                   mysql2HiveTmp_16.sh
    sed  -i   "s#__split_by__#${split_id}#g"                                mysql2HiveTmp_16.sh
    sed  -i   "s#__mr_count__#${mr_count}#g"                                mysql2HiveTmp_16.sh
    sed  -i   "s#__mapreduce_job_name__#${mapreduce_job_name}#g"            mysql2HiveTmp_16.sh
    sed  -i   "s#__log_path__#${log_path}#g"                                mysql2HiveTmp_16.sh
    sed  -i   "s#__class_name__#${class_name}#g"                            mysql2HiveTmp_16.sh
    sed  -i   "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g"          mysql2HiveTmp_16.sh
    sed  -i   "s#__query_state__#${query_state}#g"                          mysql2HiveTmp_16.sh
    sed  -i   "s#__everyday_crontab__#${everyday_crontab}#g"                mysql2HiveTmp_16.sh
    sed  -i   "s#__ods_hive_table_name__#${ods_hive_table_name}#g"          mysql2HiveTmp_16.sh
    sed  -i   "s#__jceks__#${jceks}#g"                                      mysql2HiveTmp_16.sh
    sed  -i   "s#__username__#${username}#g"                                mysql2HiveTmp_16.sh
    sed  -i   "s#__password_alias__#${password_alias}#g"                    mysql2HiveTmp_16.sh

    sed  -i   "s#__ip_addr__#${mysql_host_2}#g"                             mysql2HiveTmp_17.sh
    sed  -i   "s#__port__#${mysql_port}#g"                                  mysql2HiveTmp_17.sh
    sed  -i   "s#__db_name__#${mysql_db_name}#g"                            mysql2HiveTmp_17.sh
    sed  -i   "s#__hive_db__#ods#g"                                         mysql2HiveTmp_17.sh
    sed  -i   "s#__hive_table__#${ods_hive_table_name}#g"                   mysql2HiveTmp_17.sh
    sed  -i   "s#__split_by__#${split_id}#g"                                mysql2HiveTmp_17.sh
    sed  -i   "s#__mr_count__#${mr_count}#g"                                mysql2HiveTmp_17.sh
    sed  -i   "s#__mapreduce_job_name__#${mapreduce_job_name}#g"            mysql2HiveTmp_17.sh
    sed  -i   "s#__log_path__#${log_path}#g"                                mysql2HiveTmp_17.sh
    sed  -i   "s#__class_name__#${class_name}#g"                            mysql2HiveTmp_17.sh
    sed  -i   "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g"          mysql2HiveTmp_17.sh
    sed  -i   "s#__query_state__#${query_state}#g"                          mysql2HiveTmp_17.sh
    sed  -i   "s#__everyday_crontab__#${everyday_crontab}#g"                mysql2HiveTmp_17.sh
    sed  -i   "s#__ods_hive_table_name__#${ods_hive_table_name}#g"          mysql2HiveTmp_17.sh
    sed  -i   "s#__jceks__#${jceks}#g"                                      mysql2HiveTmp_17.sh
    sed  -i   "s#__username__#${username}#g"                                mysql2HiveTmp_17.sh
    sed  -i   "s#__password_alias__#${password_alias}#g"                    mysql2HiveTmp_17.sh

fi




sed -i "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g" overwritehive.sh
sed -i "s#__columns__#${columns}#g"                         overwritehive.sh
sed -i "s#__primary_key__#${primary_key}#g"                 overwritehive.sh
sed -i "s#__ods_hive_table_name__#${ods_hive_table_name}#g" overwritehive.sh
sed -i "s#__order_field__#${order_field}#g"                 overwritehive.sh

echo "----------------------get  crontab expression-------------------------------"


scriptsdir="${curr_dir}/${tardir}_view/crontab_${dwd_hive_table_name}.sh"
crontabexpr="00 00 * * * source /etc/profile; bash $scriptsdir"

echo "${crontabexpr}"
echo "${crontabexpr}" >> ${curr_dir}/crontab.log

cd ${curr_dir}
echo "-------------------------------exit 0----------------------"



