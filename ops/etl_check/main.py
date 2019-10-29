# -*- coding: utf-8 -*-
# @Time     : 6/6/18 6:21 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
-d db -t table -m update/insert/check -s status  -f check.txt
-m update  -d db -t table -s 1
-m insert  -d db -t table
-m check  -f check.txt

"""


import sys
import getopt
import os


from etl_check.getid import get_id
from etl_check.save import SaveDB
from etl_check.check import CheckTable

check_txt = """
-d  数据库
-t  指定表名
-s  更新状态，当指定 -m 为 update 时需要指定此选项
-f  指定check 的文件名，当指定 -m 为 check时需要指定此选项
-i  用户自定义的消息，可选配置

-m  操作的模式， 可选 update insert check
    
   check.txt 说明；当 -m check 时需要指定 file xxxx.txt
   1. 1 表示按月，如 当前为5月，则检测为 update_time >= 2018-05-01 00:00:00 则条件成立
   2. 负整数表示按天检测更新日期，当前日期 减去传入的历史天数 如当前日期为 2018-05-03，传入数字为‘-1’
      则检测时间为 update_time >= 2018-05-02 00:00:00 则条件成立
   3. 0为默认值,当天
   4. 下面的写法均正确
ods.ods_app_dim_shop   -1
ods.ods_app_dim_goods   0
ods.ods_app_dim_cate
ods.ods_app_dim_member 1
"""

import logging
import logging.config
conf_path = os.environ.get('CURR_DIR')
# conf_path="D:\git_jenkins_azkaban\etl_check"
# print("conf_path:",conf_path)
logging.config.fileConfig(conf_path + '/logging.ini')

logger = logging.getLogger('check_table_main')


logger.debug("<-----------------------进入检测程序----------------------->")



def usage():
    print(u"使用方法:")
    print(u"check_table  -m update  -d db_name -t table_name -s 1/2 '1 : 错误; 2 : 成功'")
    print(u"check_table  -m insert  -d db_name -t table")
    print(u"check_table  -m check  -f check.txt ")
    print(u"more: check_table -h/--help ")


if len(sys.argv) < 2:
    usage()

try:
    opts, args = getopt.getopt(sys.argv[1:], "ho:d:t:m:s:f:i:u:g",
                               ["help", "output=", "database", "table", "module", "status", "file", "info", "out_time", "group"])
except getopt.GetoptError as e:
    print("xxxxxxx : {}".format(e))
    usage()
    exit(1)
    # print help information and exit:

output = ''
module = ''
status = ''
database = ''
check_file = ''
table = ''
info = ''
out_time = ''
group = ''
for opt, arg in opts:
    if opt in ("-h", "--help"):
        usage()
        print(check_txt)
    if opt in ("-o", "--output"):
        output = arg
    if opt in ("-m", "--module"):
        module = arg
    if opt in ("-s", "--status"):
        status = arg
    if opt in ("-d", "--database"):
        database = arg
    if opt in ("-f", "--file"):
        check_file = arg
    if opt in ("-t", "--table"):
        table = arg
    if opt in ("-i","--info"):
        info = arg
    if opt in ("-u","--out_time"):
        out_time = arg
    if opt in ("-g","--group"):
        group = arg
logger.debug("output=%s, module=%s, status=%s, database=%s, check_file=%s, table=%s, info=%s, out_time=%s, group=%s" %(output, module, status, database, check_file, table, info, out_time, group))

if module == "update":
    if database == '' or table == '' or status == '':
        usage()
    else:
        sd = SaveDB(database, table, status)
        sd.update()
if module == "insert":
    if database == '' or table == '':
        usage()
    else:
        get_id()
        logger.debug("CHECK_TABLE_ID : %s" % os.environ.get('CHECK_TABLE_ID'))
        sd = SaveDB(database, table)
        sd.insert()


if module == "check":
    if check_file == '':
        usage()
    else:
        ct = CheckTable(check_file)
        if info != '':
            ct.set_info(info)
        if out_time != '':
            ct.set_outtime(out_time)
        if group != '':
            ct.set_wechat_group(group)
        ct.tab_check()
