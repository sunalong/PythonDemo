# -*- coding: utf-8 -*-
"""
@time: 11/10/17 1:45 PM
@author:    zhaoshun
@contact:   tmby1314@163.com
@desc:
"""

import logging.config
import os
import re
import socket
import sys
from configparser import ConfigParser

from com.itcode.ops.sqoop import timeDeal
# from com.itcode.ops.sqoop.mailSend import Mail
from com.itcode.ops.sqoop.timeDeal import check_time
from com.itcode.utils.WechartRobot import WechartRobot

conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))
# print("conf_path:",conf_path)
logging.config.fileConfig(conf_path + '/config/logging.ini')

# 错误行中含有下列的不要报警
exceptList=["Error 0"
,"KeyError: 'is_partition'"
,"WARN  Engine - prioriy set to 0, because NumberFormatException, the value is: null"
,"Exception in createBlockOutputStream"
,"no length prefix available"
,"is not locked"
,"Got error, status message , ack with firstBadLink as"
,"java.io.IOException: Bad connect ack with firstBadLink as"
,"ERROR downstreamAckTimeNanos: 0, targets"
,"Failed to encode '扫码购' in character set 'ISO-8859-1'"
,"java.net.SocketTimeoutException: 75000 millis timeout while waiting for channel to be ready for read. ch"
,"bad datanode DatanodeInfoWithStorage"
,"Bad response ERROR for block"
]

class ShellWarn(object):
    def __init__(self):
        self.conf = ConfigParser()
        self.conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))
        self.params = []
        self.error = ""
        self.message = {}

    def get_config(self):

        conf_file = '/'.join((self.conf_path, "config/conf.ini"))
        if not os.path.exists(conf_file):
            print(conf_file, "is not exists, exit 1")
            exit(1)
        with open(conf_file, "r") as fd:
            # self.conf.readfp(fd, "rb")
            self.conf.read_file(fd, "rb")

    def get_table_info(self):
        conf_file = '/'.join((self.conf_path, "config/tab.cfg"))
        with open(conf_file, 'r') as fd:
            lines = fd.readlines()
            for line in lines:
                line = line.strip()
                if len(line) != 0:
                    self.params.append(line.split())

    def main(self):
        self.get_config()
        self.get_table_info()
        # print ("self.conf_path:",self.conf_path)
        # print self.params
        curr_date = timeDeal.get_date()['date']
        now_time = timeDeal.get_date()['mtime']
        print("----------check start : ", now_time + "---------------")
        root_dir = self.conf.get("dir", "sqoop_dir")
        # print self.params
        for line in self.params:
            # 防止类似行内容为"::00 "的干扰
            if len(line) < 2:
                print("fuck line len:",len(line))
                continue
            schedule_time = line[0]
            table_name = line[1]
            increase_time = self.conf.get("time", "increase_time")
            print("table_name fuck: ", table_name)
            if not check_time(schedule_time, increase_time):
                print(table_name, u": 未到检测时间")
                continue
            log_name = ''.join((table_name, "_", curr_date, ".log"))
            target_file = '/'.join((root_dir, table_name, log_name))
            # print("target_file_fuck:",target_file)
            if not os.path.exists(target_file):
                # message_key = ''.join((table_name, " : ", target_file))
                self.message[log_name] = ''.join(("Log file is not exists !"))
                continue
            self.deal_error(target_file, log_name)
        # print self.message
        if len(self.message) == 0:
            print("Not found error")
            exit(0)
        warn_text = "\n"
        for tab, mess in self.message.items():
            warn_text = ''.join((warn_text, "<-- ", tab, " -->\n", mess, "\n"))
        # url = self.conf.get("url", "url")

        print(warn_text)
        # mail_send = Mail()
        # wm = WarnMessage(url=url)
        # wm.send_message(warn_text)
        # mail_send.do_mail(warn_text)
        now_time = timeDeal.get_date()['mtime']
        print("----------mail send end : ", now_time + "---------------")

    def deal_error(self, file_name, log_name):
        # print file_name
        print("fil_name fuck:", file_name)
        print("log_name fuck:", log_name)
        error_list = []
        report_msg="日志文件："+file_name+"\n主机名："+socket.gethostname()
        # report_msg="日志文件："+log_name
        mode = re.compile(self.conf.get("error", "list"))
        error_line=''
        with open(file_name, 'r') as fd:
            for line in fd:
                if re.search(mode, line):
                    for e in exceptList:
                        if line.__contains__(e):
                            print(" __contains__ :",line)
                            line=''
                            pass
                    error_list.append(line)
                    error_line += line

        # if len(error_list) != 0:
        if len(str.strip(''.join(error_list))) != 0:
            # message_key = ''.join((table_name, " : ", file_name))
            self.message[log_name] = ''.join(error_list)
            # Todo 开始报警
            # Todo 找点错误日志文件，放到指定目录下
            # Todo 路径、表名、主机名、错误信息
            report_msg+="\n异常信息："+error_line
            print("reportmsg fuck:",report_msg,":strip len:",len(str.strip(''.join(error_list))))
            WechartRobot().alert(group=WechartRobot.task_exception_group, msg=report_msg)

if __name__ == '__main__':
    sw = ShellWarn()
    # sw.warn()
    sw.main()
