#! /bin/bash -x 


#01. 获取时间，取前一天00:00:00到当前时间的数据
currentDate=`date +%Y-%m-%d`
currentTime=`date +%H:%M:%S`
beforeDay=`date +%Y-%m-%d -d '-2 day'`


for((i=1; i<=16; i++));
   do

#02. 根据时间将数据导入到临时表
ip_addr="__ip_addr__"
port="__port__"
db_name="__db_name___${i}"
hive_db="__hive_db__"
hive_table="__hive_table__"
split_by="__split_by__"
mr_count="__mr_count__"
mapreduce_job_name="__mapreduce_job_name__"
log_path="__log_path__"
class_name="__class_name__"
ods_hive_table_name="__ods_hive_table_name__"
query_state="__query_state__"
#query_states="$query_state __everyday_crontab__"
query_states="$query_state \$CONDITIONS"
sqoop import \
-Dhadoop.security.credential.provider.path=__jceks__  \
--connect  "jdbc:mysql://${ip_addr}:${port}/${db_name}?connectTimeout=600000&socketTimeout=600000&useUnicode=true&characterEncoding=utf-8&tinyInt1isBit=false&autoReconnect=true&failOverReadOnly=false" \
--username __username__ \
--password-alias __password_alias__ \
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
--fields-terminated-by '\0005' \
--lines-terminated-by "\n" \
--target-dir /user/sqoop/ods/${ods_hive_table_name} \
--query "${query_states}"

done;