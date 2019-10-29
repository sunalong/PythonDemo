#!/usr/bin/env bash
"""
一：在神策kudu中建库建表，并导入数据：
    1.登录神策：
        [sqoop@10-10-64-79 sal]$ impala-shell   -i 10.19.144.247:21000


        [10.19.144.247:21000] > show databases;
        Query: show databases
        +------------------+----------------------------------------------+
        | name             | comment                                      |
        +------------------+----------------------------------------------+
        | _impala_builtins | System database for Impala builtin functions |
        | default          | Default Hive database                        |
        | dim_db           |                                              |
        | rawdata          |                                              |
        +------------------+----------------------------------------------+
        Fetched 4 row(s) in 0.01s

    2.创建库：
        [10.19.144.247:21000] > create database dm;
        Query: create database dm
        Fetched 0 row(s) in 0.24s

    3.创建表：
        [10.19.144.247:21000] > use dm;
        Query: use dm
        [10.19.144.247:21000] > show tables;
        Query: show tables
        Fetched 0 row(s) in 0.01s

        完整的建表语句为：
            drop table if exists dm.dm_yh_member_life_cycle ;
            create table dm.dm_yh_member_life_cycle(
              dim_member_id string  NOT NULL COMMENT '会员id'
            , sdt string  NOT NULL COMMENT '源表分区字段'
            , insert_time string COMMENT '表中数据更新时间'
            , yhdj_member_life_label_sub  string comment '永辉到家用户生命周期子标签:1-忠诚用户 2-低频用户_1 3-低频用户_2 4-培育用户_新用户培育 5-培育用户_预备忠诚_0 6-培育用户_预备忠诚_1 7-培育用户_预备忠诚_2 8-新客用户 9-无效用户 10-流失用户 11-沉睡用户'
            , yhdj_member_life_label string comment '永辉到家用户生命周期标签:1-忠诚用户 2-低频用户 3-新用户培育 4-忠诚用户培育 5-新客用户 6-无效用户 7-流失用户 8-沉睡用户'
            , yhdj_last_1_15_day_order bigint COMMENT '永辉到家至今1-15天订单数'
            , yhdj_last_16_30_day_order bigint COMMENT '永辉到家至今16-30天订单数'
            , yhdj_last_31_45_day_order bigint COMMENT '永辉到家至今31-45天订单数'
            , yhdj_last_46_60_day_order bigint COMMENT '永辉到家至今46-60天订单数'
            , yhdj_last_61_75_day_order bigint COMMENT '永辉到家至今61-75天订单数'
            , yhdj_last_76_90_day_order bigint COMMENT '永辉到家至今76-90天订单数'
            , yhdj_last_1_7_day_order bigint COMMENT '永辉到家至今1-7天订单数'
            , yhdj_last_8_14_day_order bigint COMMENT '永辉到家至今8-14天订单数'
            , yhdj_last_15_21_day_order bigint COMMENT '永辉到家至今15-21天订单数'
            , yhdj_last_22_28_day_order bigint COMMENT '永辉到家至今22-28天订单数'
            , yhdj_last_29_35_day_order bigint COMMENT '永辉到家至今29-35天订单数'
            , PRIMARY KEY (dim_member_id,sdt)
            )
            PARTITION BY HASH (dim_member_id,sdt) PARTITIONS 3
            STORED AS KUDU TBLPROPERTIES ('kudu.master_addresses'='data02.yonghuinew.sa:7051,data01.yonghuinew.sa:7051,data03.yonghuinew.sa:7051');


    4.在impala-shell中交互式执行:
        insert into dm.dm_yh_member_life_cycle values
         ('100000322720309794','20190412',0,1,0,0,0,0,0,0,0,1,0,'5','8','2019-04-13 05:18:03.528')
        ,('100000935239659072','20190412',28,11,0,0,0,4,2,15,13,0,0,'4','7','2019-04-13 05:18:03.528');

    5.命令执行：
        [sqoop@10-10-64-79 sal]$ impala-shell   -i 10.19.144.247:21000 -f dest_data.sql


二：将hdfs表中的数据导出来：
    1.脚本：
        [sqoop@10-10-64-79 sal]$ cat life_cycle.sql
        insert overwrite local directory '/home/sqoop/sal/result'
        row format delimited
        fields terminated by '\t'
        select *
        from dm.dm_yh_member_life_cycle
        where sdt in ('20190410','20190411');
    2.命令：
        [sqoop@10-10-64-79 sal]$ hive -f life_cycle.sql

    3.执行导入：
        根据导出的数据集结果，使用python代码来生成dest_data.sql,
        然后执行 impala-shell 命令导入即可：
            [sqoop@10-10-64-79 sal]$ impala-shell   -i 10.19.144.247:21000 -f dest_data.sql

    4.效率：
        每插入五万条数据，用时 17.53 秒
        Query progress can be monitored at: http://data04:25000/query_plan?query_id=e746eac8dd4cbbc8:96b81cc00000000
        Modified 50000 row(s), 0 row error(s) in 17.53s


三：建表时需要 获取 kudu master地址：
    1.登录神策服务器：
        root ucloud.123cn【有用】
        Sc
        root HHteP2rSew10CAJ6

    2.使用root用户来登录，但一定要切换sa_cluster用户：
        ~ ⌚ 16:34:56
        $ ssh root@10.19.144.247
        root@10.19.144.247's password:
        Last failed login: Thu Apr 25 16:35:13 CST 2019 from 10.10.177.20 on ssh:notty
        There were 3 failed login attempts since the last successful login.
        Last login: Tue Apr 23 20:44:20 2019 from data03.yonghuinew.sa

    3.切换到sa_cluster用户：
        [root@data04 ~]# sudo su - sa_cluster
        Last login: Thu Apr 25 14:47:25 CST 2019 from data01.yonghuinew.sa on pts/0
        Last failed login: Thu Apr 25 16:34:23 CST 2019 from 10.10.64.79 on ssh:notty
        There was 1 failed login attempt since the last successful login.
        [sa_cluster@data04 ~]$

    4.查找 monitor_tools 工具路径：
        [sa_cluster@data04 ~]$ find / -name monitor_tools 2>/dev/null
        /home/sa_cluster/bin/monitor_tools

    5.运行 monitor_tools 获取 kudu master地址：
        [sa_cluster@data04 ~]$ pwd
        /home/sa_cluster
        [sa_cluster@data04 ~]$ ./bin/monitor_tools get_config -t client -m kudu
        2019-04-25 17:07:53,387 INFO 563 kudu client conf:
        {
            "master_address": "data02.yonghuinew.sa:7051,data01.yonghuinew.sa:7051,data03.yonghuinew.sa:7051",
            "track_statistic_kudu_master_address": "data03.yonghuinew.sa:7061,data01.yonghuinew.sa:7061,data02.yonghuinew.sa:7061",
            "track_statistic_kudu_table_name": "track_statistic",
            "ts_cdh_name": "tskudu"
        }

    可知地址为：data02.yonghuinew.sa:7051,data01.yonghuinew.sa:7051,data03.yonghuinew.sa:7051

    建表语句中的 STORED AS KUDU TALPROPERTIES 中的地址设置为上面的值：
    STORED AS KUDU TBLPROPERTIES ('kudu.master_addresses'='data02.yonghuinew.sa:7051,data01.yonghuinew.sa:7051,data03.yonghuinew.sa:7051');


四：另，导入数据的其他尝试：
    注：【有格式要求，麻烦，不推荐】
    1.查看数据导入工具的目录：
        [sa_cluster@data04 ~]$ find / -name sa-importer 2>/dev/null
        /data/sensors-analytics-1.11.4280-centos7-cluster/tools/batch_importer/bin/sa-importer
        /data/sa/tools/batch_importer/bin/sa-importer
        /data/sa_cluster/runtime/update/tmp_20190422blufip7r/sensors-analytics-update-1.12-1.13-1005/tools/batch_importer/bin/sa-importer
        /data/sa_cluster/runtime/update/tmp_20190422wng69zyb/tools/batch_importer/bin/sa-importer
        /data/sa_cluster/runtime/update/tmp_20190422wng69zyb/tools_bk/batch_importer/bin/sa-importer

    2.创建数据：
        [sa_cluster@data04 sal]$ vi test.txt
        随便写一些数据即可

    3.验证数据的正确性：
        [sa_cluster@data04 ~]$ /data/sa/tools/batch_importer/bin/sa-importer --path /home/sa_cluster/sal/
            19/04/25 17:02:05 INFO : Importer start.
            19/04/25 17:02:05 INFO : Configure Importer.
            19/04/25 17:02:05 INFO : Pulling file: /home/sa_cluster/sal/test.txt
            19/04/25 17:02:05 INFO : Generating file information: [file:/home/sa_cluster/sal/test.txt, size:586]
            Bot load: 230; Os load: 135; Browser load: 187; Mobile load: 327; Done init.
            19/04/25 17:02:23 INFO : Configure ExpiredRecordFilter before: 864000000, after: 3600000
            19/04/25 17:02:23 INFO : WorkerManager start...
            19/04/25 17:02:23 INFO : started Worker [class com.sensorsdata.analytics.tools.batchimporter.Importer$1ReadFileWorker]
            ...
            19/04/25 17:02:27 INFO : Import session read 0 valid records, 5 lines can't be parsed, 0 records invalid.
            19/04/25 17:02:27 INFO : Check finished. Please note that *** data has NOT been imported ***
            19/04/25 17:02:27 INFO : If you want to do import, please use importer with args '--import --session new'
            destroy user agent successfully.


五：基于维度表创建虚拟属性
查找关联命令：
    [root@data04 ~]# find / -name sa_view_tools.sh 2>/dev/null
    /data/sensors-analytics-1.11.4280-centos7-cluster/web/bin/sa_view_tools.sh
    /data/sa/web/bin/sa_view_tools.sh
    /data/sa_cluster/runtime/update/tmp_20190422blufip7r/sensors-analytics-update-1.12-1.13-1005/web/bin/sa_view_tools.sh
    /data/sa_cluster/runtime/update/tmp_20190422wng69zyb/web/bin/sa_view_tools.sh
    /data/sa_cluster/runtime/update/tmp_20190422wng69zyb/web_bk/bin/sa_view_tools.sh


把维度表加入神策系统中:
    错误：
        /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
        -p default \
        -t dm.dm_yh_member_life_cycle \
        -e 'events.distinct_id = dm.dm_yh_member_life_cycle.dim_member_id'
    下面正确：
        /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
        -p default \
        -t dm.dm_yh_member_life_cycle \
        -e 'events.yh_userId = dm.dm_yh_member_life_cycle.dim_member_id'



        /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
        -p default \
        -t dm.dm_yh_member_wide_table \
        -e 'events.registerId = dm.dm_yh_member_wide_table.dim_member_id'


基于维度表创建虚拟属性：
    /data/sa/web/bin/sa_view_tools.sh  external_property add \
    -p default \
    -n product_manufacturer \
    -c '产品制造商' \
    -e dim_db.product_info.product_manufacturer \
    -t STRING

维度关联：
    /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
    -p default \
    -t dm.dm_yh_member_life_cycle \
    -e "events.yh_userId = dm.dm_yh_member_life_cycle.dim_member_id and regexp_replace(to_date(events.date),'-','') = dm.dm_yh_member_life_cycle.sdt"


    /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
    -p default \
    -t dm.dm_yh_member_wide_table \
    -e "events.registerId = dm.dm_yh_member_wide_table.dim_member_id and regexp_replace(to_date(events.date),'-','') = dm.dm_yh_member_wide_table.sdt"



    对维度表和虚拟属性进行删除、更新等管理操作，可以直接执行 ~/sa/web/bin/sa_view_tools.sh 命令查看相关的帮助。
    列出维度表：
        [sa_cluster@data04 ~]$ /data/sa/web/bin/sa_view_tools.sh external_dimension_table list -p default
        id: 2, name: dm.dm_yh_member_life_cycle, joinOnExpression: events.yh_userId = dm.dm_yh_member_life_cycle.dim_member_id


    移除维度表：remove
        [sa_cluster@data04 ~]$ /data/sa/web/bin/sa_view_tools.sh external_dimension_table remove -p default -t dm.dm_yh_member_life_cycle;
        [sa_cluster@data04 ~]$ /data/sa/web/bin/sa_view_tools.sh external_dimension_table list -p default
        [sa_cluster@data04 ~]$


    重新添加维度表：
        [sa_cluster@data04 ~]$ /data/sa/web/bin/sa_view_tools.sh external_dimension_table add \
        > -p default \
        > -t dm.dm_yh_member_life_cycle \
        > -e "events.yh_userId = dm.dm_yh_member_life_cycle.dim_member_id and regexp_replace(to_date(events.date),'-','') = dm.dm_yh_member_life_cycle.sdt"


        [sa_cluster@data04 ~]$ /data/sa/web/bin/sa_view_tools.sh external_dimension_table list -p default
        id: 3, name: dm.dm_yh_member_life_cycle, joinOnExpression: events.yh_userId = dm.dm_yh_member_life_cycle.dim_member_id and regexp_replace(to_date(events.date),'-','') = dm.dm_yh_member_life_cycle.sdt

展示所有虚拟属性：
/data/sa/web/bin/sa_view_tools.sh external_property list -p default

查看生产环境的维度表：
/data/sa/web/bin/sa_view_tools.sh external_dimension_table list -p production
查看生产环境的虚拟属性：
/data/sa/web/bin/sa_view_tools.sh external_property list -p production

创建虚拟属性：
/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n dim_member_id \
-c '会员id' \
-e dm.dm_yh_member_life_cycle.dim_member_id \
-t STRING


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n sdt \
-c '源表分区字段' \
-e dm.dm_yh_member_life_cycle.sdt \
-t STRING


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n insert_time \
-c '表中数据更新时间' \
-e dm.dm_yh_member_life_cycle.insert_time \
-t STRING


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_member_life_label_sub \
-c '永辉到家用户生命周期子标签' \
-e dm.dm_yh_member_life_cycle.yhdj_member_life_label_sub \
-t STRING



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_member_life_label \
-c '永辉到家用户生命周期标签:1-忠诚用户 2-低频用户 3-新用户培育 4-忠诚用户培育 5-新客用户 6-无效用户 7-流失用户 8-沉睡用户' \
-e dm.dm_yh_member_life_cycle.yhdj_member_life_label \
-t STRING



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_1_15_day_order \
-c '永辉到家至今1-15天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_1_15_day_order \
-t NUMBER



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_16_30_day_order \
-c '永辉到家至今16-30天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_16_30_day_order \
-t NUMBER


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_31_45_day_order \
-c '永辉到家至今31-45天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_31_45_day_order \
-t NUMBER

/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_46_60_day_order \
-c '永辉到家至今46-60天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_46_60_day_order \
-t NUMBER


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_61_75_day_order \
-c '永辉到家至今61-75天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_61_75_day_order \
-t NUMBER

/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_76_90_day_order \
-c '永辉到家至今76-90天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_76_90_day_order \
-t NUMBER



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_1_7_day_order \
-c '永辉到家至今1-7天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_1_7_day_order \
-t NUMBER



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_8_14_day_order \
-c '永辉到家至今8-14天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_8_14_day_order \
-t NUMBER



/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_15_21_day_order \
-c '永辉到家至今15-21天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_15_21_day_order \
-t NUMBER


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_22_28_day_order \
-c '永辉到家至今22-28天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_22_28_day_order \
-t NUMBER


/data/sa/web/bin/sa_view_tools.sh external_property add \
-p default \
-n yhdj_last_29_35_day_order \
-c '永辉到家至今29-35天订单数' \
-e dm.dm_yh_member_life_cycle.yhdj_last_29_35_day_order \
-t NUMBER



"""