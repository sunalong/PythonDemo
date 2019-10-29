# -*- coding: utf-8 -*-


import requests
import json
import sys

"""
@time: 11/11/17 12:43 AM
@author:    zhaoshun
@contact:   tmby1314@163.com
@desc:
"""

# reload(sys)
# sys.setdefaultencoding("utf-8")


class WarnMessage(object):
    def __init__(self, url='http://192.168.190.132:8383/todos/todo1'):
        self.url = url
        self.param = {}

    def send_message(self, message):
        self.param['name'] = 'bi_report'
        self.param['type'] = '1'
        self.param['touser'] = '1'
        self.param['message'] = message
        self.param['remark'] = 'hdfs and hive warn'
        self.param['sign'] = '091e9826a57a3e6f39aab32d906868c2'

        self.do_warn(self.param)

    def do_warn(self, param):
        payload = json.dumps(param)

        headers = {
            'content-type': "application/json",
            'cache-control': "no-cache",
        }
        response = requests.request("POST", self.url, data=payload, headers=headers)

        ret = response.text
        print(ret)
        return None
