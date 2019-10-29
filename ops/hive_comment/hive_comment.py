# -*- coding: utf-8 -*-

from configparser import ConfigParser

import pymysql

from com.itcode.ops.hive_comment.addComment import GetMysqlComment, GetMysqlComment2


class AddCommentToHive(object):
    def __init__(self, ):
        self.my_ip = None
        self.my_port = 3306
        self.my_user = None
        self.my_password = None
        self.my_db = None
        self.my_table = None
        self.mmc = None
        self.config = ConfigParser()
        self.get_db_connect_info()
        self.hmc = GetMysqlComment(self.config.get("hive_meta", "ip"),
                                   int(self.config.get("hive_meta", "port")),
                                   self.config.get("hive_meta", "user"),
                                   self.config.get("hive_meta", "password"),
                                   self.config.get("hive_meta", "db_name"))
        self.my_dict = {}  # 用于存储源字段和注释
        self.parms = []    # 保存用户配置放到列表中


    """初始化配置信息"""

    def get_db_connect_info(self, ):

        with open("./config.ini", "r") as fd:
            self.config.readfp(fd, "rb")
        #print self.config.get("mysql", "ip")

    """ 获取源MYSQL中的表的字段和注释信息到‘my_dict’ """

    def get_comment_info(self,my_db, my_table):

        # self.my_ip = '10.10.74.248'
        # self.my_port = '3306'
        # self.my_user = 'bi_editer'
        # self.my_password = 'bi_editer!@qwaszx'
        # self.my_db = 'ods_tables'
        # self.my_table = 'table_metadata'
        # self.mmc = GetMysqlComment(self.my_ip, int(self.my_port), self.my_user, self.my_password, self.my_db)
        # self.mmc = GetMysqlComment2(self.my_ip, int(self.my_port), self.my_user, self.my_password, self.my_db)
        self.mmc=GetMysqlComment('10.10.74.248',3306, 'bi_editer','bi_editer!@qwaszx','ods_tables')

        # sql = "select COLUMN_NAME,column_comment from INFORMATION_SCHEMA.Columns where table_name='hyd_user_visits_detail_dailly' and table_schema='testcomment'"
        sql = ''.join(("select COLUMN_NAME,column_comment "
                       "from ods_tables.table_metadata "
                       "where table_name=", "'", my_table, "'",
                       " and table_schema=", "'", my_db, "'"))
        print(sql)
        effect_row = self.mmc.cursor.execute(sql)
        result = self.mmc.cursor.fetchall()

        for field_key, comment_value in result:
            # print field_key, comment_value
            self.my_dict[field_key] = comment_value

        print(self.my_dict)

    """遍历mysql中获得的注释信息，添加到HIVE的元数据库中"""

    def add_comment(self, cd_id):
        for k, v in self.my_dict.items():
            print(k, v)
            self.update_hive_meta(k, v, cd_id)
            self.hmc.execute("commit")
            #self.hmc.close()

    def update_hive_meta(self, field_string, comment_string, cd_id):
        cd_id = str(cd_id).lower()

        #fie#ld_string = field_string.decode('gb2312')
        #comment_string = comment_string.decode('gb2312')
        field_string = str(field_string).lower()
        comment_string = str(comment_string).lower()

        # update columns_v2 cv2 set cv2.`COMMENT` = 'xxxxxxxx' where cv2.CD_ID = 18 and cv2.COLUMN_NAME = 'member_state';
        sql = ''.join(("update COLUMNS_V2 cv2 set cv2.`COMMENT` = ", "'", comment_string, "'",
                       " where cv2.CD_ID = ", "'", cd_id, "'",
                       " and cv2.COLUMN_NAME = ", "'", field_string, "'"))
        print(sql)
        self.hmc.execute(sql)

    def get_hive_cd_id(self, hive_db, hive_table, ):
        sql = ''.join(("select  cv2.CD_ID "
                       "  from COLUMNS_V2   cv2  where cv2.CD_ID  = "
                       "( select SDS.CD_ID from SDS  where SDS.SD_ID = "
                       "( SELECT TBLS.SD_ID  from TBLS  "
                       "where TBLS.TBL_NAME = ", "'", hive_table, "'",
                       " and TBLS.DB_ID = ( "
                       "select DBS.DB_ID from DBS "
                       "where DBS.`NAME` =  ", "'", hive_db, "'",
                       " ) ) limit 1 )", " limit 1 "))
        print(sql)
        effect_row = self.hmc.cursor.execute(sql)
        result = self.hmc.cursor.fetchall()
        cd_id = result[0][0]
        print(cd_id)
        return cd_id
    """读取用户的配置文件，获取数据库和表的信息"""
    def get_config(self):
        with open("./table.cfg") as fd:
            lines = fd.readlines()
            for line in lines:
                line = line.strip()
                if len(line) != 0:
                    single_parm = line.split()
                    print(type(single_parm))
                    print(single_parm)
                    parm_dict = {}

                    parm_dict['mysql_db'] = single_parm[0]
                    parm_dict['mysql_table'] = single_parm[1]
                    parm_dict['hive_db'] = 'dwd'
                    parm_dict['hive_table'] = 'dwd_'+single_parm[0]+'__'+single_parm[1]
                    self.parms.append(parm_dict)

    def main_exec(self):
        self.get_config()
        print(self.parms)
        for parm in self.parms:
            print(parm)
            cd_id = self.get_hive_cd_id(parm['hive_db'], parm['hive_table'])
            self.get_comment_info(parm['mysql_db'],parm['mysql_table'])
            self.add_comment(cd_id)
            addcom.close()

    def close(self):

        self.mmc.close()


if __name__ == '__main__':
    addcom = AddCommentToHive()
    addcom.main_exec()
    # mmc = pymysql.connect(host='10.10.74.248', port=3306, user='bi_editer', passwd='bi_data_reporter!qaz', db='ods_tables', charset='utf8').cursor()
