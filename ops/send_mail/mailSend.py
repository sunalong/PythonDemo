# -*- coding: utf-8 -*-

import smtplib
import os
import sys
from configparser import ConfigParser
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header
from email.mime.base import MIMEBase

from email import encoders

import logging
import logging.config
import datetime

class Mail(object):
    log = logging.getLogger(__name__)

    def __init__(self):

        for i in range(0,len(sys.argv)):
            print(str(i)+": "+sys.argv[i])
        self.conf_path = os.path.dirname(os.path.abspath(sys.argv[1]))
        self.get_config()

    def get_config(self):
        self.configParser = ConfigParser()
        conf_file = '/'.join((self.conf_path, "conf.ini"))

        self.log.debug("conf_file : %s", conf_file)
        if not os.path.exists(conf_file):
            print(conf_file, "is not exists, exit 1")
            exit(1)
        with open(conf_file, "r") as fd:
            self.configParser.read_file(fd, "rb")

        now_date = datetime.datetime.now()
        self.zw_date = now_date.strftime("%Y年%m月%d日")
        self.yw_date = now_date.strftime("%Y%m%d")
        self.mail_subject = self.configParser.get('mail', 'subject')
        self.receiver = self.configParser.get('mail', 'receiver')
        self.receiver = self.receiver +",sunalong@yonghui.cn"

        self_conf_file = '/'.join((self.conf_path, "../../self_conf.ini"))
        self.selfConfigParser = ConfigParser()
        with open(self_conf_file, "r") as fd:
            self.selfConfigParser.read_file(fd, "rb")

        self.mail_host = self.selfConfigParser.get('mail', 'host')  # 设置服务器
        self.mail_user = self.selfConfigParser.get('mail', 'user')  # 用户名
        self.mail_pass = self.selfConfigParser.get('mail', 'pass')  # 授权码
        self.mail_port = self.selfConfigParser.get('mail', 'port')
        self.sender = self.selfConfigParser.get('mail', 'sender')


    def getAttachement(self):
        contype = 'application/octet-stream'
        maintype, subtype = contype.split('/', 1)

        file_name = '/'.join((self.conf_path, "data/"+self.mail_subject+"_"+self.yw_date+".zip"))
        file_data = open(file_name,'rb')
        # file_msg = email.MIMEBase.MIMEBase(maintype, subtype)
        file_msg = MIMEBase(maintype, subtype)
        file_msg.set_payload(file_data.read())
        file_data.close( )
        encoders.encode_base64(file_msg)
        basename = os.path.basename(file_name)
        file_msg.add_header('Content-Disposition', 'attachment', filename = basename)
        # msg.attach(file_msg)
        return file_msg


    def do_mail(self):
        # 第三方 SMTP 服务

        receivers = self.receiver.split(',')  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
        print(receivers)

        # message = MIMEText(message, 'plain', 'utf-8')
        message = MIMEMultipart()
        message['From'] = self.sender
        message['To'] = self.receiver
        message['Subject'] = Header(self.mail_subject, 'utf-8')
        # try: Todo: python3 的异常捕获

        smtp_obj = smtplib.SMTP()
        smtp_obj.connect(self.mail_host, self.mail_port)  # 25 为 SMTP 端口号
        #smtp_obj.ehlo()
        #smtp_obj.starttls()
        smtp_obj.login(self.mail_user, self.mail_pass)
        file_msg = self.getAttachement()
        message.attach(file_msg)

        mail_test_msg="""
        你好:
            {0}_{1}.zip 已上传至附件中, 请查收.
            
            
            ps:如果打开中文乱码，解决方法如下：
            打开excel，执行”数据”->”新建查询”->从文件->”从csv”->文件原始格式 改为  "无"->'加载'
        
                  永辉云创数据产品
        
        {2}
        """.format(self.mail_subject,self.yw_date,self.zw_date)
        text_msg = MIMEText(mail_test_msg, _charset='utf-8')
        message.attach(text_msg)
        smtp_obj.sendmail(self.sender, receivers, message.as_string())
        self.log.info("邮件发送成功")
        smtp_obj.quit() # 发送员之后退出


if __name__ == '__main__':
    mail = Mail()
    mail.do_mail()
