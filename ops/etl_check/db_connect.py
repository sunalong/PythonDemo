# -*- coding: utf-8 -*-
# @Time     : 5/28/18 5:46 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""

import configparser

import pymysql
import os
import logging
import logging.config


class DBManager(object):
    logger = logging.getLogger(__name__)

    def __init__(self):
        self.curr_dir = os.environ.get('CURR_DIR')
        self.cursor = None
        self.conn = None
        self.create_connect()

    def create_connect(self):
        conf = configparser.ConfigParser()
        mysql_ini='/'.join((self.curr_dir, "mysql.ini"))
        conf.read(mysql_ini, "utf-8")
        self.conn = pymysql.connect(conf.get("db", "ip"), conf.get("db", "user"), conf.get("db", "passwd"),
                             conf.get("db", "db"))
        self.cursor = self.conn.cursor()

    def check(self, sql):
        try:
            self.cursor.execute(sql)
            self.conn.commit()
        except:
            self.conn.rollback()
        return self.cursor.fetchall()

    def update(self, sql):
        try:
            self.cursor.execute(sql)
            self.conn.commit()
        except:
            self.cursor.rollback()

    def tmp_test(self):
        self.logger.debug(self.cursor.execute("INSERT INTO `t_check_hive_etl` (`db`, `table`,`status`)  VALUES ('ods','ods_app_dim_shop',2) ON DUPLICATE KEY UPDATE status = 2;"))
        self.logger.debug(self.cursor.lastrowid)
        self.conn.commit()

    def close(self):
        self.cursor.close()
        self.conn.close()


if __name__ == '__main__':
    dm = DBManager()
    dm.tmp_test()

