
CREATE TABLE data_governance.dim_dwd_table_info (
  `hive_table_name` varchar(254)  COMMENT '要检测的Hive表名',
  `max_field` varchar(254) DEFAULT 'last_updated_at' COMMENT '增量列，如last_updated_at 取max(last_updated_at),可以为空',
  `last_crontab_time` varchar(254) COMMENT '最近一次调度完成时间',
  `partition_field` varchar(254) DEFAULT NULL COMMENT '分区字段名字',
  UNIQUE KEY `db_table_index_u` (`hive_table_name`) USING BTREE
) ;

-- INSERT INTO data_governance.dim_dwd_table_info (hive_table_name,max_field,partition_field) VALUES
-- ('dwd_dbbos__lost','last_updated_at','sdt'),