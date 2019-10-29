# coding:utf-8

import hashlib
import urllib3
import json
import certifi
import click

class AlertRobot:

    def __init__(self,group_name):
        # 秘钥
        self.key = "5OxyQ3jr9JsKoDZF4nIOlxVGjnJnnVjD"
        # 固定的分组类型
        self.type = "groupchat"
        self.name = group_name
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

@click.command()
@click.option("--msg",help='发送要发送的信息')
@click.option("--group",help='四个群聊组')
def alert_wechat(msg,group):
    """ 使用方式： exception_alert --msg '负责人（模块）：报错信息' --group '大数据实时应用预警'
        group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        **严重注意**：参数顺序不能变，按照上面例子中的顺序书写
    """
    ar = AlertRobot(group)
    ar.send_message(msg)


if __name__ == '__main__':
    # alert_wechat("测试","大数据作业异常预警")
    alert_wechat()