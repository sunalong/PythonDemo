# coding:utf-8

import hashlib
import urllib3
import json
import certifi
import click


class AlertRobot:

    def __init__(self):
        # 秘钥
        self.key = "5OxyQ3jr9JsKoDZF4nIOlxVGjnJnnVjD"
        # 固定的分组类型
        self.type = "groupchat"
        self.name = "大数据实时应用预警"
        # 对应企业微信报警机器人的群组名称
        # 数据组四个群组：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        self.remark = "云创大数据组",
        self.url_method = "post"
        self.url = "http://ops.yonghuivip.com/report/push"

        # 获取签名值
    def get_sign(self,key, type, name):
        md5_para = key + type + name
        h = hashlib.md5()
        h.update(md5_para.encode('utf-8'))
        sign_str = h.hexdigest()
        return sign_str

    def send_message(self,message):
        sign = self.get_sign(self.key, self.type, self.name)
        # post参数
        url_para = {"type": self.type, "name": self.name, "message": message, "remark": self.remark, "sign": sign}
        self.do_request(self.url,url_para)

    def do_request(self, url, url_para):
        url = url
        jdata = json.dumps(url_para)
        http = urllib3.PoolManager(
            timeout=urllib3.Timeout(connect=3, read=2.0),
            retries=urllib3.Retry(3, redirect=2),
            cert_reqs='CERT_REQUIRED',
            ca_certs=certifi.where()
        )
        http.request(method=self.url_method, url=url, body=jdata, headers={"Content-Type":"application/json"})

    def do_com_request(self,url):
        http = urllib3.PoolManager(
            timeout=urllib3.Timeout(connect=3, read=2.0),
            retries=urllib3.Retry(3, redirect=2),
            cert_reqs='CERT_REQUIRED',
            ca_certs=certifi.where()
        )
        rs = http.request(method='get', url=url)
        if 200 != rs.status:
            return {"msg":"HTTP Status : "+ str(rs.status),"code":str(rs.status) }

        return json.loads(rs.data.decode())

@click.command()
@click.option("--url",help='输入要检查的网址')
@click.option("--msg",help='输入提示信息')
def alert_wechat(url,msg):
    """ 使用方式： exception_alert.py --msg '负责人（模块）：报错信息' --url "http://www.baidu.com"
    """
    ar = AlertRobot()
    rs = ar.do_com_request(url)
    print(rs)
    if 0 != rs["code"] :
        ar.send_message(msg + str(rs["msg"])+ '\n url：' + url)

if __name__ == '__main__':
    alert_wechat()
