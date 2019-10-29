# -*- coding: utf-8 -*-
# @Time     : 6/3/18 10:52 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""

import sys
import getopt
from etl_check.db_connect import DBManager
from etl_check.GetTimes import get_date
import os
import time

# db=sys.argv[1]
# table=sys.argv[2]
# status=sys.argv[3]

import logging
import logging.config


class CheckService(object):
    logger = logging.getLogger(__name__)

    def __init__(self):
        # 长时间检测时不应该长期占用一个链接
        # self.dbManager = DBManager()
        self.meta_table = "t_check_hive_etl"
        self.result = {}
        self.check_tab_id = os.environ.get('CHECK_TABLE_ID')

    def insert(self, db, table):
        dbManager = DBManager()
        status=str(0)
        sql = ''.join((" INSERT INTO `t_check_hive_etl` (`db`, `table`,`status`,`check_tab_id`) "
                       " VALUES (", "'", db, "',",  "'", table, "',",  status, ",", "'", self.check_tab_id, "'", ")", ";"))
        self.logger.debug(sql)
        dbManager.update(sql)
        dbManager.close()


    def update(self, db, table, status):
        self.logger.debug("update record ")

        row_dict = self.query(db, table)
        t_id = None
        if row_dict:
            t_id = row_dict['id']
        else:
            print("没有找到初始化的插入记录")
        self.logger.debug("id %s" % t_id)

        dbManager = DBManager()
        status = str(status)
        t_id = str(t_id)
        sql = ''.join(("update `t_check_hive_etl` set `status` = ", status, " where id = ", "'", t_id, "'", ";"))
        self.logger.debug(sql)
        dbManager.update(sql)
        dbManager.close()

    def query(self, db, table, start_time=None):
        dbManager = DBManager()
        self.result.clear()
        if start_time is None:
            start_time = get_date()['date']
        sql = ''.join(("SELECT `id`, `status`,`db`,`table`,`start_time`,`end_time`,`check_tab_id` FROM `t_check_hive_etl`  t ",
                       " where t.db = ", "'", db, "'",
                       " and t.table =",  "'", table, "'",
                       " and t.start_time >= ", "'", start_time, "'",
                       " ORDER BY t.id DESC limit 1"))
        self.logger.debug(sql)
        ret = dbManager.check(sql)
        if ret:
            record = ret[0]
            self.logger.debug(record[0])
            self.result['id'] = record[0]
            self.result['status'] = record[1]
            self.result['db'] = record[2]
            self.result['table'] = record[3]
            self.result['start_time'] = record[4].strftime('%Y-%m-%d %H:%M:%S')
            self.result['end_time'] = record[5].strftime('%Y-%m-%d %H:%M:%S')
            self.result['check_tab_id'] = record[6]
        self.logger.debug(self.result)
        dbManager.close()
        return self.result


if __name__ == '__main__':
    pass
    # print(db, table, status)
    # cs = CheckService()
    # cs.insert(db,table)
    # print("update")
    # time.sleep(2)

    # cs.update(db, table, 1)
    # cs.query(db, table, status)







