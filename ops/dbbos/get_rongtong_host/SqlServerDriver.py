# -*- coding: utf-8 -*-
# @Time     : 11/24/18 6:59 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""

import pymssql
from DBUtils.PooledDB import PooledDB


class MysqlDriver(object):
    __instance = None

    def __new__(cls):
        if cls.__instance is None:
            print("----new  MysqlDriver----")
            cls.__instance = object.__new__(cls)
        return cls.__instance

    def __init__(self):
        self.pool = PooledDB(creator=pymssql
                             , mincached=2
                             , maxcached=5
                             , maxshared=3
                             , maxconnections=6
                             , blocking=True
                             , host='10.2.12.11'
                             , user='rtqh'
                             , password='rtqh8899'
                             , database='dbbos'
                             , charset="utf8"
                             )
        self.conn = self.pool.connection()

    def insert_single(self, sql):
        try:
            cur = self.conn.cursor()
            print(sql)
            ret = cur.execute(sql)
            id = cur.lastrowid
            self.conn.commit()
            return id
        except Exception as e:
            print(e)
            self.conn.rollback()

    def query(self, sql):
        try:
            cur = self.conn.cursor()
            print(sql)
            cur.execute(sql)
            ret = cur.fetchall()
            return ret
        except Exception as e:
            print(e)

    def inserts(self, sql, params):
        try:
            cur = self.conn.cursor()
            # print("params : %s" % params)
            print("**************************************")
            cur.executemany(sql, params)
            self.conn.commit()
        except Exception as e:
            print(e)
            self.conn.rollback()


class get_rongtong_host_info(object):

    def __init__(self):
        self.md = MysqlDriver()

    # 去除五家店（四家闭店，一家连不上，都没人使用）
	# 9K16 因表结构不一致，史路隽建议去除2019-05-09
    def query(self):
        ret = self.md.query(
            "select ServerName,ShopID  from VersionCtrl_DB t "
            "where (t.ShopID like '9D%' OR T.ShopID LIKE '9I%' or t.ShopID LIKE '9K%') and t.ShopID not in('9K13','9K16','9I19','9K09','9I27','9D54');")
        return ret

    def write_file(self, host_tuple_list):
        if host_tuple_list:
            print(host_tuple_list)

            with open('./host_shop.txt', 'w+', encoding='utf8') as saveFile:
                for tuple_line in host_tuple_list:
                    print(tuple_line)
                    info_line = "{:<15} {}\n".format(tuple_line[0],tuple_line[1])
                    saveFile.write(info_line)
            with open('./add_partition_modult.sql', 'w+', encoding='utf8') as saveFile:
                for tuple_line in host_tuple_list:
                    print(tuple_line)
                    info_line = "alter table ods_tmp.__HIVE_ODS_TMP_TABLE__ add if not exists partition(datelabel=__DATELABEL__,shop_id='{0}') location 'datelabel=__DATELABEL__/shop_id={1}';\n".format(tuple_line[1],tuple_line[1])
                    saveFile.write(info_line)


    def main(self):
        host_tuple_list = self.query()
        self.write_file(host_tuple_list)


if __name__ == '__main__':
    gthi = get_rongtong_host_info()
    gthi.main()
