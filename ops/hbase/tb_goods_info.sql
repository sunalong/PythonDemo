drop table if exists share_data.out_unified_goods_info2;
CREATE TABLE `share_data.out_unified_goods_info2`(
  `id` bigint COMMENT '每天-自增id',
  `goods_id` string COMMENT '商品ID',
  `goods_name` string COMMENT '商品名',
  `brand_id` string COMMENT '品牌ID',
  `category_id` string COMMENT '小类ID',
  `unit` string COMMENT '单位',
  `spec_prop` string COMMENT '规格',
  `main_img` string COMMENT '主图',
  `list_img` string COMMENT '列表图',
  `last_updated_at` string COMMENT '数据更新时间')
stored as orc
LOCATION 'hdfs://Ucluster/user/sqoop/public/share_data/out_unified_goods_info2'
