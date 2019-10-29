#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
#----------------------首次导入-----------------------------------------
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

echo "mysql_host=$mysql_host"
echo "mysql_port=$mysql_port"
echo "mysql_db_name=$mysql_db_name"
echo "mysql_table_name=$mysql_table_name"
echo "primary_key=$primary_key"
echo "order_field=$order_field"
echo "mr_count=$mr_count"
echo "ods_hive_table_name=$ods_hive_table_name"
echo "split_id=$split_id"

if [ "$#" -lt "7" ]; then

 echo "Error11: expect 2 param"
 echo "useage: sh etl.sh  10.9.164.106 3310  member_center  t_member_address  id  last_updated_at 2 "
 exit 11;
fi


bash -x ${curr_dir}/create_ods_dwd_table.sh  "$@"
#Todo：若新增字段，则先创建临时表，把dwd表数据导入进去，再重建dwd表，将临时表数据导入进来
#新表默认无数据,此操作不影响速度 老表有数据,如果还需要etl 一般默认为新增字段
bash -x ${curr_dir}/add_new_fields.sh   "$@"

bash -x ${curr_dir}/create.sh ${mysql_db_name} ${mysql_table_name}

#nohup hive -f add_partitions.sql &>./log_add_partition.log &
echo "开始添加分区..."
hive -f ${curr_dir}/${mysql_table_name}_view/add_partitions.sql  &>${curr_dir}/${mysql_table_name}_view/nohup.out

# 到task39 下才能执行
#./ods_flume_json_${mysql_db_name}__${mysql_table_name}/crontab_ods_flume_json_mms_msm_center__msm_sku_shop.sh



