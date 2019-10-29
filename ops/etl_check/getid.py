# -*- coding: utf-8 -*-
# @Time     : 6/6/18 8:04 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""
import datetime
import os


def get_id():
    now_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')
    os.environ['CHECK_TABLE_ID'] = now_time
    # print(os.environ.get('CHECK_TABLE_ID'))
