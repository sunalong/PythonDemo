# -*- coding: utf-8 -*-

import pymysql
import pyhs2

"""
获取连接并执行任务
"""

class GetMysqlComment(object):
    def __init__(self, mysql_host="192.168.190.10", mysql_port=3306, mysql_user="test", mysql_passwd="123456", mysql_db="testcomment"):
        self.mysql_host = mysql_host
        self.mysql_port = mysql_port
        self.mysql_user = mysql_user
        self.mysql_passwd = mysql_passwd

        self.mysql_db = mysql_db

        conn = pymysql.connect(host=self.mysql_host, port=self.mysql_port, user=self.mysql_user,
                               passwd=self.mysql_passwd, db=self.mysql_db, charset='utf8')
        self.cursor = conn.cursor()

    def execute(self, sql, params=None):
        return self.cursor.execute(sql, params)

    def fetch(self, sql, params=None):
        self.execute(sql, params)
        return self.cursor.fetchone()

    def fetchall(self, sql, params=None):
        self.execute(sql, params)
        return self.cursor.fetchall()

    def close(self):
        return self.cursor.close()


class GetMysqlComment2(object):
    def __init__(self, mysql_host="192.168.190.10", mysql_port=3306, mysql_user="test", mysql_passwd="123456", mysql_db="testcomment"):
        self.mysql_host = mysql_host
        self.mysql_port = mysql_port
        self.mysql_user = mysql_user
        self.mysql_passwd = mysql_passwd

        self.mysql_db = mysql_db

        conn = pymysql.connect(host=self.mysql_host, port=self.mysql_port, user=self.mysql_user,
                               passwd=self.mysql_passwd, db=self.mysql_db, charset='utf8')
        self.cursor = conn.cursor()

    def execute(self, sql, params=None):
        return self.cursor.execute(sql, params)

    def fetch(self, sql, params=None):
        self.execute(sql, params)
        return self.cursor.fetchone()

    def fetchall(self, sql, params=None):
        self.execute(sql, params)
        return self.cursor.fetchall()

    def close(self):
        return self.cursor.close()




class AddHiveComment(object):
    def __init__(self, hs2_host="192.168.190.10", hs2_port=10000, hs2_authMechanism="PLAIN", hs2_user="hivetest"
                 , hs2_password="123456",  hs2_db="default"):
        self.hs2_host = hs2_host
        self.hs2_port = hs2_port
        self.hs2_authMechanism = hs2_authMechanism
        self.hs2_user = hs2_user
        self.hs2_password = hs2_password
        self.hs2_db = hs2_db

        conn = pyhs2.connect(host=self.hs2_host, port=self.hs2_port, authMechanism=self.hs2_authMechanism,
                             user=self.hs2_user,
                             password=self.hs2_password, database=self.hs2_db)
        self.cur = conn.cursor()

    def execute(self, sql):
        return self.cur.execute(sql)

    def close(self):
        return self.cur.close()



