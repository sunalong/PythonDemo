
-- 每天插入的表，插入之前先清空
drop table data_governance.tmp_yarn_application_info
create table data_governance.tmp_yarn_application_info (
  app_id PRIMARY KEY varchar(100) comment 'application id'
, app_name varchar(100) comment 'application name'
, app_type varchar(100) comment 'application 类型'
, user varchar(20) comment '执行本application的用户'
, queue varchar(100) comment '本application位于的队列'
, start_time bigint(16) comment 'application 开始时间戳'
, finish_time bigint(16) comment 'application 结束时间戳'
, mem_value  bigint(16) comment '分配的聚合内存量'
, vcore_value  bigint(16) comment '分配的聚合vcore量'
, mem_unit   varchar(20) comment '聚合内存量的单位'
, vcore_unit varchar(20) comment '聚合vcore量的单位'
, progress varchar(10) comment '执行进度'
, state varchar(20) comment '执行状态'
, final_state varchar(20) comment '最终状态'
, tracking_url varchar(200) comment '任务url'
, rpc_port varchar(10) comment 'rpc 端口'
, am_host varchar(100) comment 'am host'
, insert_time timestamp DEFAULT CURRENT_TIMESTAMP comment '数据插入时间'
) engine=innodb default charset=utf8 comment='yarn application 信息表';



-- 全量表；与tmp表一起去重写到dwd到，再由dwd回写而来
drop table data_governance.ods_yarn_application_info
create table data_governance.ods_yarn_application_info (
  app_id PRIMARY KEY varchar(100) comment 'application id'
, app_name varchar(100) comment 'application name'
, app_type varchar(100) comment 'application 类型'
, user varchar(20) comment '执行本application的用户'
, queue varchar(100) comment '本application位于的队列'
, start_time bigint(16) comment 'application 开始时间戳'
, finish_time bigint(16) comment 'application 结束时间戳'
, mem_value  bigint(16) comment '分配的聚合内存量'
, vcore_value  bigint(16) comment '分配的聚合vcore量'
, mem_unit   varchar(20) comment '聚合内存量的单位'
, vcore_unit varchar(20) comment '聚合vcore量的单位'
, progress varchar(10) comment '执行进度'
, state varchar(20) comment '执行状态'
, final_state varchar(20) comment '最终状态'
, tracking_url varchar(200) comment '任务url'
, rpc_port varchar(10) comment 'rpc 端口'
, am_host varchar(100) comment 'am host'
, insert_time timestamp DEFAULT CURRENT_TIMESTAMP comment '数据插入时间'
  PRIMARY KEY (app_id)
) engine=innodb default charset=utf8 comment='yarn application 信息表';

""

-- 全量表；对外提供的表
drop table data_governance.dwd_yarn_application_info
create table data_governance.dwd_yarn_application_info (
  app_id PRIMARY KEY varchar(100) comment 'application id'
, app_name varchar(100) comment 'application name'
, app_type varchar(100) comment 'application 类型'
, user varchar(20) comment '执行本application的用户'
, queue varchar(100) comment '本application位于的队列'
, start_time bigint(16) comment 'application 开始时间戳'
, finish_time bigint(16) comment 'application 结束时间戳'
, mem_value  bigint(16) comment '分配的聚合内存量'
, vcore_value  bigint(16) comment '分配的聚合vcore量'
, mem_unit   varchar(20) comment '聚合内存量的单位'
, vcore_unit varchar(20) comment '聚合vcore量的单位'
, progress varchar(10) comment '执行进度'
, state varchar(20) comment '执行状态'
, final_state varchar(20) comment '最终状态'
, tracking_url varchar(200) comment '任务url'
, rpc_port varchar(10) comment 'rpc 端口'
, am_host varchar(100) comment 'am host'
, insert_time timestamp DEFAULT CURRENT_TIMESTAMP comment '数据插入时间'
  PRIMARY KEY (app_id)
) engine=innodb default charset=utf8 comment='yarn application 信息表';



