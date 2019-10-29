#! /bin/bash -x
declare -r curr_dir=$(cd `dirname $0`; pwd)

# 一：从 hdfs中导出数据到指定目录
sql="""
insert overwrite local directory '${curr_dir}/hdfs_data'
row format delimited
fields terminated by '\t'
select a.dim_goods_id
, b.dim_category_id
, a.goods_name
, b.category_name
, b.mcategory_code
, b.mcategory_name
, b.bcategory_code
, b.bcategory_name
, b.workshop_code
, b.work_shop_name
, b.small_group_code
, b.small_group_name
, b.class_code
, b.class_name
, b.group_code
, b.group_name
, b.dept_code
, b.dept_name
, cast(current_timestamp as varchar(19)) as insert_time
from dim.dim_category b
join dim.dim_goods a on a.dim_category_id=b.dim_category_id
"""
echo "sql:" $sql
rm ${curr_dir}/hdfs_data/*
hive -e "${sql}"  &>${curr_dir}/log.log
cat ${curr_dir}/hdfs_data/00* >${curr_dir}/hdfs_data/dest_file

#拷贝数据、清空表、添加数据、刷新
sshpass -p gvU4p5hyoA scp ${curr_dir}/hdfs_data/dest_file sa_cluster@10.19.144.247:~/dest_file &>${curr_dir}/log.log
sshpass -p gvU4p5hyoA ssh sa_cluster@10.19.144.247 "sudo -u hdfs hdfs dfs -put -f ~/dest_file /user/hive/warehouse/dim.db/dim_category_goods_sensors_txt" &>>${curr_dir}/log.log
impala-shell -i 10.19.144.247:21000 -q "refresh dim.dim_category_goods_sensors_txt"



## 二：执行 python 命令，切分文件并按格式写到多个文件中
#source /data/soft/py3__env/bin/activate
#python ${curr_dir}/insert-impala_category_goods.py  &>>${curr_dir}/log.log
#deactivate

# 每天需要先清空表
tb_file=${curr_dir}/tb_dim_category.sql
impala-shell   -i 10.19.144.247:21000 -f ${tb_file} &>>${curr_dir}/log.log

impala-shell -i 10.19.144.247:21000 -q "INSERT into dim.dim_category_goods_sensors select * from dim.dim_category_goods_sensors_txt;"

# 添加属性
echo "$(date "+%Y-%m-%d %H:%M:%S") 添加属性"  &>>${curr_dir}/log.log
sshpass -p gvU4p5hyoA scp ${curr_dir}/add_property_category_goods.sh sa_cluster@10.19.144.247:~/add_property_category_goods.sh
sshpass -p gvU4p5hyoA ssh sa_cluster@10.19.144.247 "source /etc/profile; bash -x ~/add_property_category_goods.sh" &>>${curr_dir}/log.log

#
## 三：遍历切分好的目录文件，将数据导入到impala
#
#for file in ${curr_dir}/seg_file_to_insert/*
#do
#	if [ -f $file ]
#	then
#		echo "$(date "+%Y-%m-%d %H:%M:%S") :$file"  &>>${curr_dir}/log.log
#        impala-shell   -i 10.19.144.247:21000 -f ${file}
#	fi
#done

#把 productID 添加到 yh_productId 所在的事件中,以便显示所有 后台_ 属性
#spadmin schema -m bind_event_properties --project production --event yh_elementClick --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_productReview --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_shoppingCartStatus --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_pageView --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_pageLeave --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_elementExpo --properties productID
#spadmin schema -m bind_event_properties --project production --event yh_moduleClick --properties productID