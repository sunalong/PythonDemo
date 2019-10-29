# -*- coding: utf-8 -*-

import pymysql
from DBUtils.PooledDB import PooledDB


class MysqlUtils:
    __instance = None
    sql = """ 
         select hive_table_name,records,max_field,cast(last_updated_at as char) as last_updated_at
         from data_governance.dg_check_count
         where hive_table_name like '%dwd_order_db__t_trade_order%'
           and check_date='20190301'
         """
    def __new__(cls):
        if cls.__instance is None:
            # print("----new DBDriver----")
            cls.__instance = object.__new__(cls)
        return cls.__instance

    def __init__(self):
        self.pool = PooledDB(creator=pymysql,
                             mincached=1,
                             maxcached=10,
                             host='10.10.49.190',
                             port=3306,
                             user='dev_user',
                             passwd='Ygvb456#',
                             db='data_governance',
                             charset="utf8")
        # self.pool = PooledDB(creator=pymysql,
        #                      mincached=1,
        #                      maxcached=10,
        #                      host='10.10.49.190',
        #                      port=3306,
        #                      user='check_user',
        #                      passwd='Uiop123!',
        #                      db='data_governance',
        #                      charset="utf8")
        # self.pool = PooledDB(creator=pymysql,
        #                      mincached=1,
        #                      maxcached=10,
        #                      host='10.10.64.79',
        #                      port=3306,
        #                      user='check_user',
        #                      passwd='Uiop123!',
        #                      db='config_db',
        #                      charset="utf8")
        self.conn = self.pool.connection()

    def insert_single(self, sql):
        try:
            cursor = self.conn.cursor()
            # print(sql)
            ret = cursor.execute(sql)
            id = cursor.lastrowid
            # print("ret:",ret,"  id:",id)
            self.conn.commit()
            return id
        except Exception as e:
            print(e)
            self.conn.rollback()

    def query(self,sql):
        try:
            cursor = self.conn.cursor()
            # print(sql)
            cursor.execute(sql)
            ret = cursor.fetchall()
            self.conn.close()
            return ret
        except Exception as e:
            print(e)

if __name__ == '__main__':
    md = MysqlUtils()
    # ret = md.query("select id,hive_db_name,hive_table_name,is_partition from quality_db.t_check_config")
    ret = md.query(md.sql)
    print(ret)
    # print("ret[0][0]:",ret[0][0])
    # print("ret[0][1]:",ret[0][1])
    # print("ret[0][2]:",ret[0][2])
    # print("ret[0][3]:",ret[0][3])
