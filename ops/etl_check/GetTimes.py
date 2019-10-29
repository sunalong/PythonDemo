# -*- coding: utf-8 -*-
"""
@time: 11/6/17 10:28 AM
@author:    zhaoshun
@contact:   tmby1314@163.com
@desc:
"""

import datetime
import calendar


def get_date():
    dt = {}
    now_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')
    # print now_time
    curr_date = datetime.datetime.now().strftime('%Y-%m-%d')
    # print curr_date
    curr_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    curr_month = datetime.datetime.now().strftime('%Y-%m')
    # print curr_time
    dt['date'] = curr_date
    dt['time'] = curr_time
    dt['mtime'] = now_time
    dt['first_day'] = curr_month + "-01"
    return dt


def deal_time(schedule_time):
    curr_date = get_date()['date']
    # print type(curr_date)
    dt_string = curr_date + " " + schedule_time
    schedule_time = datetime.datetime.strptime(dt_string, "%Y-%m-%d %H:%M:%S")
    # print type(schedule_time)
    # print schedule_time

    curr_time = datetime.datetime.now()
    # print type(curr_time)
    # print curr_time

    time_diff_value = (curr_time - schedule_time).seconds
    return time_diff_value


def check_time(schedule_time="00:00:00", increase_time=60):
    curr_date = get_date()['date']
    # print type(curr_date)
    dt_string = curr_date + " " + schedule_time
    schedule_datetime = datetime.datetime.strptime(dt_string, "%Y-%m-%d %H:%M:%S")
    finally_schedule_time = schedule_datetime + datetime.timedelta(seconds=int(increase_time))
    # print u"最终可以检测时间", finally_schedule_time
    curr_time = datetime.datetime.now()
    # print u"当前时间", curr_time
    if curr_time > finally_schedule_time:
        return True
    return False


def get_his_date(days=0):
    minutes = int(days)
    curr_time = datetime.datetime.now()

    his_date = curr_time - datetime.timedelta(minutes=minutes)
    his_day = curr_time + datetime.timedelta(days=days)
    # print curr_time

    his_time1 = his_date.strftime('%Y-%m-%d %H:%M:%S')
    curr_time1 = curr_time.strftime('%Y-%m-%d %H:%M:%S')
    his_day = his_day.strftime('%Y-%m-%d')
    # print(his_day)
    return his_day


def get_id():
    dt = {}
    now_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')
    dt['mtime'] = now_time
    return dt


if __name__ == '__main__':
    # print get_date()
    # deal_time("17:33:00")
    # print(check_time(schedule_time="11:15:00", increase_time=50))
    # print(get_date()['first_day'])
    print(get_id()['mtime'])
