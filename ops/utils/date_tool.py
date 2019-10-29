# -*- coding: utf-8 -*-
# @Time     : 11/12/18 2:09 PM
# @Author   : zhaoshun
# @Email    : tmby1314@163.com

"""
"""
import datetime


def get_his_date(days=0):
    curr_time = datetime.datetime.now()
    his_day = curr_time + datetime.timedelta(days=days)
    his_day = his_day.strftime('%Y%m%d')
    return his_day


def get_curr_month():
    return datetime.datetime.now().strftime('%Y%m')


def get_curr_year():
    return datetime.datetime.now().strftime('%Y')


def get_pritition_date(paritition_date):
    print(type(paritition_date))
    print("get_pritition_date : {0}".format(paritition_date))
    if paritition_date is None or paritition_date == "":
        paritition_date = -1
    if int(paritition_date) < 0:
        return get_his_date(paritition_date)
    if int(paritition_date) == 1:
        return get_curr_month()
    if int(paritition_date) == 2:
        return get_curr_year()


if __name__ == '__main__':
    print(get_his_date(days=0))
    print(get_curr_month())
    print(get_curr_year())
