#! /bin/bash -x
进入 hbase shell
    hbase shell

删除表:
    drop 'out_unified_ordertype'

创建表:
    create 'out_unified_ordertype','cf1'

datax导入数据：
    datax.py 12_out_unified_ordertype.json

查看内容:
    hbase(main):004:0> scan "out_unified_ordertype"
    ROW                                 COLUMN+CELL
     \x00\x00\x00\x00\x00\x00\x00\x01   column=cf1:id, timestamp=1558071587409, value=\x00\x00\x00\x00\x00\x00\x00\x01
     \x00\x00\x00\x00\x00\x00\x00\x01   column=cf1:ordertype_id, timestamp=1558071587409, value=ORT01
     \x00\x00\x00\x00\x00\x00\x00\x01   column=cf1:ordertype_name, timestamp=1558071587409, value=\xE9\x85\x8D\xE9\x80\x81
     \x00\x00\x00\x00\x00\x00\x00\x02   column=cf1:id, timestamp=1558071587409, value=\x00\x00\x00\x00\x00\x00\x00\x02
     \x00\x00\x00\x00\x00\x00\x00\x02   column=cf1:ordertype_id, timestamp=1558071587409, value=ORT02
     \x00\x00\x00\x00\x00\x00\x00\x02   column=cf1:ordertype_name, timestamp=1558071587409, value=\xE8\x87\xAA\xE6\x8F\x90
     \x00\x00\x00\x00\x00\x00\x00\x03   column=cf1:id, timestamp=1558071587409, value=\x00\x00\x00\x00\x00\x00\x00\x03
     \x00\x00\x00\x00\x00\x00\x00\x03   column=cf1:ordertype_id, timestamp=1558071587409, value=ORT03
     \x00\x00\x00\x00\x00\x00\x00\x03   column=cf1:ordertype_name, timestamp=1558071587409, value=\xE7\xBA\xBF\xE4\xB8\x8B\xE9\x97\xA8\xE5\xBA\x97
     \x00\x00\x00\x00\x00\x00\x00\x04   column=cf1:id, timestamp=1558071587409, value=\x00\x00\x00\x00\x00\x00\x00\x04
     \x00\x00\x00\x00\x00\x00\x00\x04   column=cf1:ordertype_id, timestamp=1558071587409, value=ORT04
     \x00\x00\x00\x00\x00\x00\x00\x04   column=cf1:ordertype_name, timestamp=1558071587409, value=\xE6\x89\xAB\xE7\xA0\x81\xE8\xB4\xAD
    4 row(s) in 0.0590 seconds



创建phoenix对应的视图:
    CREATE view "out_unified_ordertype" ( "ROW" BIGINT primary key, "cf1"."id" BIGINT,"cf1"."ordertype_id" varchar,"cf1"."ordertype_name" varchar) column_encoded_bytes=0;
    CREATE view "out_unified_ordertype" ( "ROW" INTEGER primary key, "cf1"."id" INTEGER,"cf1"."ordertype_id" varchar,"cf1"."ordertype_name" varchar) column_encoded_bytes=0;


正确的创建视图:
    CREATE view "out_unified_ordertype" ( "ROW" UNSIGNED_LONG primary key, "cf1"."id" UNSIGNED_LONG,"cf1"."ordertype_id" varchar,"cf1"."ordertype_name" varchar) column_encoded_bytes=0;

    CREATE view "out_unified_ordertype" (
        "ROW" UNSIGNED_LONG primary key
        , "cf1"."id" UNSIGNED_LONG
        , "cf1"."ordertype_id" varchar
        , "cf1"."ordertype_name" varchar
    ) column_encoded_bytes=0;

7_out_unified_goods_info.json
    CREATE view "out_unified_goods_info" (
        "ROW" UNSIGNED_LONG primary key
        , "cf1"."id" UNSIGNED_LONG
        , "cf1"."goods_id" varchar
        , "cf1"."goods_name" varchar
        , "cf1"."brand_id" varchar
        , "cf1"."category_id" varchar
        , "cf1"."unit" varchar
        , "cf1"."spec_prop" varchar
        , "cf1"."main_img" varchar
        , "cf1"."list_img" varchar
        , "cf1"."last_updated_at" varchar
    ) column_encoded_bytes=0;


14_out_unified_goods_shop_stock.json

    CREATE view "out_unified_goods_shop_stock" (
        "ROW" UNSIGNED_LONG primary key
        , "cf1"."id" UNSIGNED_LONG
        , "cf1"."shop_id" varchar
        , "cf1"."sku_code" varchar
        , "cf1"."bar_code" varchar
        , "cf1"."sap_status" varchar
        , "cf1"."active_flag" varchar
        , "cf1"."status" varchar
        , "cf1"."available_time" varchar
        , "cf1"."default_price" varchar
        , "cf1"."market_price" varchar
        , "cf1"."yh_price" varchar
        , "cf1"."stock" varchar
        , "cf1"."sdt" varchar
    ) column_encoded_bytes=0;
