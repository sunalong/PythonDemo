#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
mysql_host="$1"
mysql_port="$2"
mysql_db_name="$3"
mysql_table_name="$4"
primary_key="$5"
order_field="$6"
mr_count="$7"
ods_hive_table_name="ods_${mysql_db_name}__${mysql_table_name}"
dwd_hive_table_name="dwd_${mysql_db_name}__${mysql_table_name}"
split_id=`echo "$primary_key" | awk  -F "," '{print $1}'`

sql_file="${dwd_hive_table_name}.sql"

#Todo:1.生成临时表
cp ${curr_dir}/${sql_file} ${curr_dir}/"${dwd_hive_table_name}_tmp.sql"
sed -i "s/${dwd_hive_table_name}/${dwd_hive_table_name}_tmp/g"  ${curr_dir}/"${dwd_hive_table_name}_tmp.sql"
#hive -f ${curr_dir}/"${dwd_hive_table_name}_tmp.sql"
hive -f ${curr_dir}/"${dwd_hive_table_name}.sql"

#Todo:2.dwd表中的数据导入到临时表

#Todo:3.删除dwd表重建dwd表
#hive -f ${curr_dir}/${sql_file}
#Todo:4.临时表中的数据写入到dwd表



