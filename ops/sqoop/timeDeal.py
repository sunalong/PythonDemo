# -*- coding: utf-8 -*-
"""
@time: 11/6/17 10:28 AM
@author:    zhaoshun
@contact:   tmby1314@163.com
@desc:
"""

import datetime
import time
# import ConfigParser


def get_date():
    dt = {}
    now_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')
    # print now_time
    curr_date = datetime.datetime.now().strftime('%Y%m%d')
    curr_date1 = datetime.datetime.now().strftime('%Y-%m-%d')
    # print curr_date
    curr_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # print curr_time
    dt['date'] = curr_date
    dt['date1'] = curr_date1
    dt['time'] = curr_time
    dt['mtime'] = now_time
    return dt


def deal_time(schedule_time):
    curr_date = get_date()['date1']
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


def datetime_timestamp(dt):
    # dt为字符串
    # 中间过程，一般都需要将字符串转化为时间数组
    time.strptime(dt, '%Y-%m-%d %H:%M:%S')
    # time.struct_time(tm_year=2012, tm_mon=3, tm_mday=28, tm_hour=6, tm_min=53, tm_sec=40, tm_wday=2, tm_yday=88, tm_isdst=-1)
    # 将"2012-03-28 06:53:40"转化为时间戳
    s = time.mktime(time.strptime(dt, '%Y-%m-%d %H:%M:%S'))
    return int(s)


'''
get unix time
'''


def unix_time():
    unix_time_int = datetime_timestamp('2012-03-28 06:53:40')
    print(unix_time_int)


'''
schedule_time + increase_time = finally_time
调度时间+增量时间(s) = 最终检测时间
如果当前时间大于最终检测时间则可以本次检测
'''


def check_time(schedule_time="00:00:00", increase_time=60):
    curr_date = get_date()['date1']
    # print type(curr_date)
    dt_string = curr_date + " " + schedule_time
    schedule_datetime = datetime.datetime.strptime(dt_string, "%Y-%m-%d %H:%M:%S")
    finally_schedule_time = schedule_datetime + datetime.timedelta(seconds=int(increase_time))
    print ("最终可以检测时间", finally_schedule_time)
    curr_time = datetime.datetime.now()
    print(u"当前时间", curr_time)
    if curr_time > finally_schedule_time:
        return True
    return False


if __name__ == '__main__':
    # print get_date()
    print (deal_time("17:33:00"))
    print (unix_time())
    print (check_time(schedule_time="11:15:00", increase_time=50))
