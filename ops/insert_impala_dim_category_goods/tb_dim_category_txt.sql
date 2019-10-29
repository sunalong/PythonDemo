
-- txt表 存储快，查询慢，查询使用上面的kudu表
drop table if exists dim.dim_category_goods_sensors_txt ;
create table dim.dim_category_goods_sensors_txt(
  dim_goods_id  string  comment '商品ID'
, dim_category_id  string  comment '品类id'
, goods_name  string  comment '商品名称'
, category_name_sensors  string  comment '品类名称'
, mcategory_code  string  comment '中类编码'
, mcategory_name  string  comment '中类名称'
, bcategory_code  string  comment '大类编码'
, bcategory_name  string  comment '大类名称'
, workshop_code  string  comment '工坊编码'
, work_shop_name  string  comment '工坊名称'
, small_group_code  string  comment '小商行编码'
, small_group_name  string  comment '小商行名称'
, class_code  string  comment '课组编码'
, class_name  string  comment '课组名称'
, group_code  string  comment '商行编码'
, group_name  string  comment '商行名称'
, dept_code  string  comment '部类编码'
, dept_name  string  comment '部类名称'
, insert_time  string  COMMENT '表中数据更新时间'
)
row format delimited
fields terminated by '\t';
--
-- INSERT into dim.dim_category_goods_sensors select * from dim.dim_category_goods_sensors_txt;

