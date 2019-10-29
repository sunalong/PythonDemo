# -*- coding: utf-8 -*-
# @Time     : 5/28/18 5:47 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""
from etl_check.db_service import CheckService
from etl_check.GetTimes import get_date
from etl_check.getid import get_id
import logging
import logging.config


class SaveDB(object):
    logger = logging.getLogger(__name__)

    def __init__(self, db, table, status=0, last_updated_at=None):
        self.cs = CheckService()
        self.db = db
        self.table = table
        self.status = status
        self.last_updated_at = last_updated_at

    def update(self):
        self.cs.update(self.db, self.table, self.status)

    def insert(self):
        self.cs.insert(self.db, self.table)

    def check(self):
        if self.last_updated_at is None:
            self.last_updated_at = get_date()['date']
        return self.cs.query(self.db, self.table, self.last_updated_at)


if __name__ == '__main__':
    # get_id()
    # sd = SaveDB('ods', 'ods_app_dim_shop', 2)
    # sd.insert()
    # sd.update()

    # sd = SaveDB('ods', 'ods_app_dim_cate', 2)
    # sd.insert()
    # sd.update()
    # sd = SaveDB('ods', 'ods_app_dim_goods', 2)
    # sd.insert()
    # sd.update()

    sd = SaveDB('ods', 'ods_app_dim_member', 2)
    # sd.insert()
    sd.update()



