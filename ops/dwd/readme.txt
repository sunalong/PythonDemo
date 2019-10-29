用途：
    查询dwd层的表，将数据量，更新时间 插入到mysql190中
    如果表无数据或波动大于10%，发送报警到 大数据数据异常预警 中


详细使用步骤：
一：查询dwd层的表，将数据量等插入到mysql190中：
    1.先向表中插入更新后的数据条数，调用如下命令：
        MonitorDwd.sh i dwd_order_db__t_trade_order_item

    2.mysql 190信息：
        host=10.10.49.190
        port=3306
        user=dev_user
        passwd=Ygvb456#


二：查看波动比，并以此来报警：
    1.调用如下命令：
        MonitorDwd j dwd_order_db__t_trade_order_item
        判断表数据量的波动，如果表无数据或波动大于10%，则发送报警信息到 大数据数据异常预警 中
    2.示例如下：
        当前表：dwd_dbbos__rpgoodsstatus
        今日数据：530980
        昨日数据：530980
        环比昨日：0.00%
        主机名：uhadoop-mzwc2w-task3
        最后更新时间：2019-10-16 02:45:27.302903


三：其他
    常见使用于etl表中
    已经配置模板化了，不用手动调用，如：
    cat data_biz/etl/thirdparty_db/t_duiba_inviter_relation_view/dwd_db__table.sh
    ...
    MonitorDwd i dwd_thirdparty_db__t_duiba_inviter_relation
    MonitorDwd j dwd_thirdparty_db__t_duiba_inviter_relation


