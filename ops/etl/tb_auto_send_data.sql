
drop table if exists data_governance.auto_extract_data;


create table data_governance.auto_extract_data (
  mysql_host varchar(50) comment 'mysql的ip'
, mysql_port varchar(50)  comment 'mysql的端口'
, mysql_db_name varchar(50) comment '源库名'
, mysql_table_name  varchar(50) comment '源表名'
, primary_key  varchar(50) NOT NULL DEFAULT 'id' comment '源表主键，默认为 id'
, order_field  varchar(50) NOT NULL DEFAULT 'last_updated_at' comment '排序字段依据，默认为 last_updated_at，有可能为 last_updated_by'
, mr_count  int(1) NOT NULL DEFAULT 2 COMMENT 'mr数量，默认为2'
, username varchar(50) NOT NULL DEFAULT 'bi_sync' comment '抽数权限用户，默认 bi_sync,有可能为 usvr_analysis'
, productor varchar(100) comment '产品人员的姓名，如果有问题可直接联系该产品'
, status  int(1) NOT NULL DEFAULT 0 COMMENT '任务状态，0 数据插入默认为0，1 已经配置成功，2 更新修改'
, insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据插入时间'
, PRIMARY KEY (mysql_db_name,mysql_table_name)
)comment '配置抽数的信息'


;

alter table ods_tmp.dbbos__rpt_freshskudaily drop if exists partition(datelabel=20180929,shop_id='9DIG') ;
alter table ods.ods_flume_json_member_center__yh_super_member_operation  drop  partition(datelabel=20201227);



INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,productor)
VALUES
('10.42.83.115','3306','ofs_delivery_center','t_warehouse_delivery_order','闵红霞')


INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,order_field,productor)
VALUES
('10.42.107.45','3306','thirdparty_db','t_duiba_inviter_relation','last_updated_by','黄家昊')



INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,productor)
VALUES
('10.42.83.115','3306','ofs_delivery_center','t_delivery_exception_order','赵顺')
('10.42.140.58,10.42.132.106','3306','wms_ibd_center','ibd_none_receipt_record','')

.

select mysql_host,mysql_port,mysql_db_name,mysql_table_name,primary_key,order_field,mr_count,username,productor,status,insert_time
from data_governance.auto_extract_data




