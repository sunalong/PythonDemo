# -*- coding: utf-8 -*-
#
#  import pymysql
import prestodb


class PrestoUtils:
    # def __new__(cls):
    #     if not hasattr(cls,'instance'):
    #         cls.instance = super(PrestoUtils,cls).__new__(cls)
    #     return cls.instance

    def __init__(self):
        # self.pymysql.co
        # 打开数据库连接

        self.db = prestodb.dbapi.connect(host='ycbi-db-01', port = 8989,  user = 'sqoop', catalog = 'hive',  schema = 'ods')
        # 使用cursor() 方法创建一个游标对象 cursor
        self.cursor = self.db.cursor()
        pass

    # def getInstance(self):
    #     return self.cls.instance

    def query(self, sql):
        # 使用execute()方法执行sql查询
        self.cursor.execute(sql)
        # 使用fetchone（）方法获取单条数据
        itemList = self.cursor.fetchall()
        fields = self.cursor.description
        # print("fields:",fields)
        ret_dict={"fields":fields,"itemList":itemList}
        return ret_dict

    def count(self, sql):
        # 使用execute()方法执行sql查询
        self.cursor.execute(sql)
        # 使用fetchone（）方法获取单条数据
        record_cnt = self.cursor.fetchall()
        # print("record_cnt:",record_cnt[0][0])
        fields = self.cursor.description
        # print("fields:",fields[0][0])
        ret_dict={"fields":fields[0][0],"record_cnts":record_cnt[0][0]}
        return ret_dict
    def __del__(self):
        # 关闭游标及数据库连接
        # self.cursor.close()
        self.db.close()


if __name__ == '__main__':
    # PrestoUtils.getInstance().query("select shop_name from dim.dim_shop limit 10")
    db = PrestoUtils()
    # ret_dict = db.query("select * from dim.dim_shop limit 10")
    # print("field:",end="")
    # for field in ret_dict["fields"]:
    #     print(field[0],"|",end="")
    # print()
    # i=0
    # for item in ret_dict["itemList"]:
    #     # print(item)
    #     print(i,':',item)
    #     i=i+1
    countSql = "select count(1) as record_cnt from dwd.dwd_order_db__t_trade_order_item where substring(last_updated_at,1,10)='2018-12-23'"

    ret=db.count(countSql)
    print("ret",ret)
