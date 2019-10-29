一：功能描述：
    一次性查询所有dwd层的表，查看各表数据的更新状态
    每天更新一遍dwd表，数据波动异常则预警到群：大数据数据异常预警

    日志打印如下：
        当前表：dwd_yh_pay_center__yh_cash_gift
        今日数据：2105064
        昨日数据：2105064
        环比昨日：0.00%
        主机名：uhadoop-mzwc2w-task2
        max(last_updated_at)：2018-12-05 17:56:59.946881
        最近一次调度完成时间：2019-01-18 00:05

二：信息说明：
    max(last_updated_at):用于查看json是否正常传来，调度即使正常，但数据可能没过来
    最近一次调度完成时间:用于与max对比，判断本表是否需要下线



三：设计思路：
  1.获取当前所有dwd表信息，插入表中
    使用脚本 get_dwd_table_info.sh 来获取截止代码运行时，当前dwd层的所有的表，
    将表信息插入 data_governance.dim_dwd_table_info 中 (mysql190)
    表结构信息参见 tb_dwd_table_info.sql

  2.查询dwd所有表的波动，预警
    根据上一步的  data_governance.dim_dwd_table_info 中的数据，
    查询每个dwd表的昨日数据量与今日数据量的波动比，如果波动为0或波动大于10%，则预警
    由于本调度于每天07:30开始执行，所以07:30之后才ETL的表，放到 special_tab.cfg 文件中
    如果当时时间小于本表的指定的更新时间，不必执行波动的查询与判断

