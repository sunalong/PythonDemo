# -*- coding: utf-8 -*-
# @Time     : 5/28/18 5:47 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
1. 读取文本中的db.table，查询数据表判断该表是否已经准备好了
"""

# from etl_check.db_connect import DBManager
from datetime import datetime

from decimal import Decimal

from etl_check.WechartRobot import WechartRobot
from etl_check.db_service import CheckService
import configparser
from etl_check.GetTimes import get_date, get_his_date
import time
import os
import logging
import logging.config


class CheckTable(object):
    logger = logging.getLogger(__name__)

    def __init__(self, check_file=None):
        self.curr_dir = os.environ.get('CURR_DIR')
        # self.dbManager = DBManager()
        self.meta_table = "t_check_hive_etl"
        self.result = {}
        self.not_pass_dict = {}
        self.success_dict = {}
        self.tab_dict = {}
        self.cs = CheckService()
        self.tab_list = []
        self.conf = None
        self.get_conf()
        self.get_tabs(check_file)
        check_file_path=os.path.abspath(check_file)
        self.father_path = os.path.abspath(os.path.dirname(check_file_path) + os.path.sep + ".")
        print("check_file_path:",check_file_path)
        print("father_path:",self.father_path)
        self.info=None
        self.out_time = None
        self.group = None

        # self.parse_config()
    def set_info(self,info):
        self.info=info
        print("self.info:",self.info)

    def set_outtime(self,out_time):
        self.out_time=out_time
        print("self.out_time:",self.out_time)

    def set_wechat_group(self,set_wechat_group):
        self.group=set_wechat_group
        print("self.group:",self.group)

    def get_conf(self):
        self.conf = configparser.ConfigParser()
        mysql_ini='/'.join((self.curr_dir, "mysql.ini"))
        # mysql_ini="./mysql.ini"
        self.conf.read(mysql_ini, "utf-8")

    def get_tabs(self,check_file):
        with open(check_file, 'r') as fd:
            for line in fd:
                line = line.strip()
                if not len(line) or line.startswith('#'):
                    continue
                self.tab_list.append(line)
        if not self.tab_list:
            return
        for tab_time in self.tab_list:
            tab_time_list = tab_time.split()
            # print(tab_time_list)
            # print(len(tab_time_list))
            if len(tab_time_list) == 1:
                tab_time_list.append('0')
            # print(tab_time_list)
            if len(tab_time_list) > 1:
                self.tab_dict[tab_time_list[0]] = tab_time_list[1]

    def tab_check(self):
        self.logger.debug("开始依赖检测")
        if not self.tab_dict:
            self.logger.info("本次检忽略，没有发现要依赖的表")
            return True
        self.logger.info("本次检测如下表： %s " % self.tab_dict)
        interval = self.conf.getint("db", "interval")
        if interval is None:
            interval = 10
        self.logger.debug("interval %s"% interval)

        start_time = datetime.now()
        # Todo:2.超时时间 可由用户传进来

        out_time=3600
        if self.out_time is None:
            print("self.out_time is None")
        else:
            out_time = self.out_time


        # Todo:3.微信群组 可由用户传进来
        group="大数据作业异常预警"
        if self.group is None:
            print("self.set_wechat_group is None")
        else:
            group = self.group

        report_time_out = 0

        while True:
            curr_time = datetime.now()
            if ((curr_time - start_time).seconds >= int(out_time)):
                # Todo:1.自定义的消息 可由用户传进来
                resultMsg = ""
                if self.info is None:
                    print("self.info is None")
                else:
                    resultMsg +="user_msg:" +self.info +"\n"
                    print("self.info in use:", self.info)

                report_time_out+=Decimal((curr_time - start_time).seconds / 60).quantize(Decimal('0.00'))
                resultMsg+="任务已经检测超时："+str(report_time_out) + " 分钟"+"\n任务路径："+self.father_path+"\n未通过的表为：\n"
                for db_tab, message in self.not_pass_dict.items():
                    resultMsg+=db_tab+" "+message+"\n"
                    # self.logger.info("%s %s" % (db_tab, message))
                print("start rebot 报警:" + resultMsg)
                WechartRobot().alert(group=group, msg=resultMsg)
                # 报警一次后，半小时再报
                start_time = datetime.now()

            self.not_pass_dict.clear()
            self.parese_dict()
            if self.not_pass_dict:

                self.logger.info("<---------------------检测通过,列表如下---------------------->")

                for db_tab, message in self.success_dict.items():
                    self.logger.info("%s %s" % (db_tab, message))
                self.logger.info("<---------------------检测未通过,列表如下-------------------->")
                for db_tab, message in self.not_pass_dict.items():
                    self.logger.info("%s %s" % (db_tab, message))
                self.logger.info("等待%s秒后再次检测" % interval)
                time.sleep(interval)
                continue
            else:
                self.logger.debug("<---------------------检测通过,列表如下---------------------->")
                for db_tab, message in self.success_dict.items():
                    self.logger.info("%s %s" % (db_tab, message))
                return True

    def parese_dict(self):

        for key, value in self.tab_dict.items():
            self.logger.debug("%s, %s" % (key, value))
            db_table_list = key.split(".")
            self.logger.debug(db_table_list)
            if len(db_table_list) < 2:
                self.logger.debug("请按正确格式填写 db.table, exit !!! ")
            db = db_table_list[0]
            table = ""
            if len(db_table_list) > 2:
                for line in db_table_list:
                    table = '.'.join((table, line))
            else:
                table = db_table_list[1]
            time_flag = value
            self.logger.debug("%s, %s, %s" % (db, table, time_flag))
            db_tab = '.'.join((db, table))

            if self.check_and_sleep(db, table, time_flag):
                self.not_pass_dict[db_tab] = "检测到其他错误，如格式问题等"
                return False

    def check_and_sleep(self, db, table, time_flag):
        self.result.clear()
        self.logger.debug("%s, %s, %s" % (db, table, time_flag))
        time_flag = int(time_flag)
        start_time = ''
        # 1 表示按月
        if 1 == time_flag:
            start_time = get_date()['first_day']
        elif time_flag <= 0:
            start_time = get_his_date(time_flag)
        else:
            self.logger.debug("请正确填写历史天数，历史天数只能 <= 1, 如 0, -1, -2 ")
            return False

        self.logger.debug("%s, %s, %s" % (db, table, start_time))
        self.result = self.cs.query(db, table, start_time)
        db_tab = '.'.join((db, table))
        self.logger.debug("%s.%s 检测时间： %s  检测结果： %s " % (db, table, start_time, self.result))
        if not self.result:
            self.logger.debug("%s.%s 检测时间： %s  检测结果为空： %s " % (db, table, start_time, self.result))
            self.not_pass_dict[db_tab] = "未检测到更新记录 !!!"
        else:
            status = self.result['status']
            if status == 1:
                self.not_pass_dict[db_tab] = "检测到表更新错误 !!!"
            elif status == 0:
                self.not_pass_dict[db_tab] = "检测到表更新中 ..."
            elif status == 2:
                self.success_dict[db_tab] = "该表已更新"


if __name__ == '__main__':
    ct = CheckTable("check.txt")
    ct.set_info("销售七张表，已经超时，请尽快处理：@陈凯、@孙阿龙")
    ct.set_outtime(4)
    ct.set_wechat_group("大数据作业失败预警")
    # ct.get_tabs()
    print(ct.tab_list)
    print(ct.tab_dict)
    ct.tab_check()
