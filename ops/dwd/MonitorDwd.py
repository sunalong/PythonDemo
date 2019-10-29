# -*- coding: utf-8 -*-
# 查询dwd层重要的订单七张表，
# 有数据，且波动在10%以内，将信息插入到mysql并提示
# 无数据或波动大于10%，将信息插入到mysql并@相关人报警
# Todo:查询失败的处理
# dwd.dwd_order_db__t_trade_order_item
# import datetime
import datetime
import sys

params=sys.argv[1]

print(params)

from com.itcode.ops.dwd.MonitorDwdHelper import MonitorDwdHelper


class MonitorDwd:

    def __init__(self):
        self.curr_date=datetime.datetime.now().strftime('%Y-%m-%d')


    def insertToMysql(self, current_table):
        # 将查询的结果插入到mysql中
        MonitorDwdHelper().insertToMysql(current_table)


    def judge(self,current_table):
        # 判断mysql的结果,根据结果来报警或提示
        # group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        # 按序号 将各表ETL情况发送到一个新的正常提示预警群里
        MonitorDwdHelper().judge(current_table)

# @click.command()
# @click.option("--method",help='发送要发送的信息')
# @click.option("--current_table",help='发送要发送的信息')
def command(method,current_table):
    if 'insertToMysql' == method:
        MonitorDwd().insertToMysql(current_table)
    elif 'judge' == method:
        MonitorDwd().judge(current_table)


if __name__ == '__main__':
    #MonitorDwd().insertToMysql(MonitorDwdHelper.current_table)
    #MonitorDwd().judge(MonitorDwdHelper.current_table)
    # command()

    command(sys.argv[1],sys.argv[2])
