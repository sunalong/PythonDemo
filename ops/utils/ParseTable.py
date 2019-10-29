# INSERT INTO `dg_check_config` VALUES (122, 'dw', 'dwb_tk_sku_shop_stock_yhsh', 1, 'last_updated_at', 1, 'sdt', 'string', null, null);
# CREATE TABLE `dg_check_config` (
#   id bigint(20) COMMENT '自增主键',   -- 可以设置
#   hive_db_name varchar(254) COMMENT '要检测的Hive数据库名',
#   hive_table_name varchar(254) COMMENT '要检测的Hive表名',
#   is_partition int(11) COMMENT '是否分区表',
#
#
#
#   max_field varchar(254) COMMENT '增量列，如last_updated_at 取max(last_updated_at),可以为空',
#
#
#
#   is_available int(11) COMMENT '该记录是否生效',
#   partition_field varchar(254) COMMENT '分区字段名字',
#   partition_field_type varchar(254) COMMENT '分区字段类型int,string',
#   partition_flag int(11) COMMENT '分区日期（此处只考虑按天月年分区的表）暂时不支持按非日期分表,0代表当前日期，-n 代表前n天 ，1 代表按月分区，2代表按年分区，默认值-1',
#   catalog_value varchar(254) COMMENT '数据表在presto上的catalog名字，默认为hive',
#   PRIMARY KEY (`id`) USING BTREE,
#   UNIQUE KEY `db_table_index_u` (`hive_db_name`,`hive_table_name`) USING BTREE
# ) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8