Author:sunalong
Email:466210864@qq.com
Date:2019-10-16 10:30

使用方法：
    一：将需要ETL的表信息插入到mysql中
    二：读取mysql中的配置信息，生成配置文件
    三：根据配置文件，生成ETL所需的文件

具体使用步骤：
    一：插入表信息到mysql中
        1.在mysql 190中执行如下语句：
            INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,productor)
            VALUES
            ('10.42.186.96','3306','member_center','yh_dues_bill','黄家昊')

        2.mysql 190信息：
            host=10.10.49.190
            port=3306
            user=dev_user
            passwd=Ygvb456#
        3.data_governance.auto_extract_data表信息路径：
            com/itcode/ops/etl/tb_auto_send_data.sql


    二：读取mysql配置信息，生成配置文件：
        1.执行shell脚本生成配置信息：
            [sqoop@uhadoop-mzwc2w-task39 etl]$ bash read_mysql_for_extract.sh
            [sqoop@uhadoop-mzwc2w-task39 etl]$ pwd
            /data/soft/PY_Tools/com/itcode/ops/etl

        2.生成的配置文件内容如下:
            [sqoop@uhadoop-mzwc2w-task39 etl]$ cat conf.ini
            [db]
            mysql_host=10.9.28.119
            mysql_port=3306
            mysql_db_name=member_center
            mysql_table_name=yh_dues_bill
            primary_key=id
            order_field=last_updated_at
            mr_count=2
            username=bi_sync
            productor=黄家昊
            status=0


    三：根据配置文件，生成ETL所需的文件
        1.执行shell脚本生成ETL文件：
            [sqoop@uhadoop-mzwc2w-task39 etl]$ bash etl_mv.sh
            [sqoop@uhadoop-mzwc2w-task39 etl]$ pwd
            /data/soft/PY_Tools/com/itcode/ops/etl
        生成ETL文件后，会自动将文件move到data_biz工程指定目录下，
        可查看上一步最后几行的日志,如：
            ...
            开始添加分区...
            + db_dir=/data/app/dev/data_biz/etl/thirdparty_db
            + '[' '!' -d /data/app/dev/data_biz/etl/thirdparty_db ']'
            + echo $'\347\233\256\345\275\225\345\255\230\345\234\250\357\274\232/data/app/dev/data_biz/etl/thirdparty_db'
            目录存在：/data/app/dev/data_biz/etl/thirdparty_db
            + mv /data/soft/PY_Tools/com/itcode/ops/etl/init_module/ods_flume_json_thirdparty_db__t_duiba_inviter_relation /data/app/dev/data_biz/etl/thirdparty_db/
            + mv /data/soft/PY_Tools/com/itcode/ops/etl/init_module/t_duiba_inviter_relation /data/app/dev/data_biz/etl/thirdparty_db/
            + mv /data/soft/PY_Tools/com/itcode/ops/etl/init_module/t_duiba_inviter_relation_view /data/app/dev/data_biz/etl/thirdparty_db/
            + mv /data/soft/PY_Tools/com/itcode/ops/etl/init_module/dwd_thirdparty_db__t_duiba_inviter_relation.sql /data/app/dev/data_biz/etl/thirdparty_db/
            + mv /data/soft/PY_Tools/com/itcode/ops/etl/init_module/dwd_thirdparty_db__t_duiba_inviter_relation_tmp.sql /data/app/dev/data_biz/etl/thirdparty_db/


其他说明：
    1.支持分库分表的ETL:
        示例如下：
            INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,productor)
            VALUES
            ('10.42.119.2,10.42.154.60','3306','map_center','map_adjust','彭虎')
            其中前一个ip 10.42.119.2  中的分库类似于：map_center_${i},其中i的值属于[1,16]
            其中后一个ip 10.42.154.60 中的分库类似于：map_center_${i},其中i的值属于[17,32]

    2.抽数权限用户名可变：
        默认 bi_sync,有可能为 usvr_analysis，如果不是bi_sync则需要指明，如：
            INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,username,productor)
            VALUES
            ('10.9.164.106','3310','account_center','sys_user','usvr_analysis','闵红霞')

    3.mysql源表排序字段名可变：
        默认为 last_updated_at，有可能为 last_updated_by，如：
            INSERT into data_governance.auto_extract_data(mysql_host,mysql_port,mysql_db_name,mysql_table_name,order_field,productor)
            VALUES
            ('10.42.142.217','3310','thirdparty_db','t_duiba_super_inviter','last_updated_by','高小叶')

    4.ETL任务只能一次一个表
        生成配置文件是根据mysql表中的status字段来判定；
        如果是新插入的则为0，脚本读取表中status值为0的行，写入到配置文件中，
        表信息写入到配置文件后，status的值被置为1，
        如果需要修改要抽取的表的信息，则将status的值改为2

    5.默认功能：
        a.历史数据抽取并etl到dwd:
            脚本目录如：etl/map_center/map_adjust
            一次性将历史数据抽取并etl到dwd：bash crontab_ods_map_center__map_adjust.sh
            如果数据量大于一万条，则只能晚上八点之后再操作这一步
        b.生成拉链表形式更新的脚本，创建ods_view表，并添加分区
            脚本目录如：etl/map_center/map_adjust_view
            调度需要配置两个：
            将拉链ETL数据到dwd：55 00 * * * source /etc/profile; bash /data/app/dev/data_biz/etl/map_center/map_adjust_view/crontab_dwd_map_center__map_adjust.sh
            将dwd数据回写到ods：39 11 * * * source /etc/profile; bash /data/app/dev/data_biz/etl/map_center/map_adjust_view/crontab_dwd_map_center__map_adjust_to_ods.sh
        c.生成flume伪实时抽取数据的脚本：
            脚本目录如：etl/map_center/ods_flume_json_map_center__map_adjust
            需要在task39机器上执行脚本，如：bash crontab_ods_flume_json_map_center__map_adjust.sh
        d.如果之前有相同的表，再次执行上述etl步骤则会将之前的表的meta信息删除
            但外部表数据是保留的，如果要变更字段，需要将ods的数据和ods_view对应的数据手动删除
