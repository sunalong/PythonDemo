drop table if exists share_data.out_unified_goods_shop_stock2;
CREATE TABLE `share_data.out_unified_goods_shop_stock2`(
  `id` bigint,
  `shop_id` string,
  `sku_code` string,
  `bar_code` string,
  `sap_status` string,
  `active_flag` string,
  `status` string,
  `available_time` string,
  `default_price` double,
  `market_price` double,
  `yh_price` double,
  `stock` double)
PARTITIONED BY (
  `sdt` string)
stored as orc
LOCATION 'hdfs://Ucluster/user/sqoop/public/share_data/out_unified_goods_shop_stock2';


Todo:
登录到flink集群，然后执行语句：
alter table share_data.out_unified_goods_shop_stock2 add if not exists partition(sdt='20190521');