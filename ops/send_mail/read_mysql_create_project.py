# -*- coding: utf-8 -*-
import datetime
import os
import shutil
import sys

from com.itcode.utils.MysqlUtils import MysqlUtils


class ReadMysql:
    def __init__(self):
        for i in range(0,len(sys.argv)):
            print(str(i)+": "+sys.argv[i])
        self.conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))+"/projects"
        print("conf_path:"+self.conf_path)
        self.curr_date=datetime.datetime.now().strftime('%Y-%m-%d')
        self.execSql = "select subject, sql_str, fields_comment, receiver, productorTel, productorName, crontab, status, insert_time  from data_governance.auto_send_email where status<>1"

        self.today = datetime.datetime.now()
        self.delta = datetime.timedelta(days=1)
        self.end_date = self.today.strftime('%Y%m%d')
        self.start_date = (self.today - self.delta).strftime('%Y%m%d')


    def getdata(self):
        retLists = MysqlUtils().query(self.execSql)
        resultMsg = ""
        for item in retLists:
            print(str(item) + "\n")
            self.createProject(item)


        # WechartRobot().alert(group=WechartRobot.data_exception_group, msg=resultMsg)
        print("resultMsg:\n", resultMsg)

    def createProject(self,item):
        subject = str(item[0])
        sql_str = str(item[1])
        fields_comment = str(item[2])
        receiver = str(item[3])
        productorTel = str(item[4])
        productorName = str(item[5])
        crontab = str(item[6])
        status = str(item[7])
        insert_time = str(item[8])
        update_sql="""
        update data_governance.auto_send_email set status=1 where subject='{0}'
        """.format(subject)
        if status != "1":
            print("fuck:"+update_sql)
            retLists = MysqlUtils().insert_single(update_sql)
            print("改变数据状态："+str(retLists))
            # Done:创建文件夹 #如果状态为0，表明新插入的，需要设置
            project_dir=self.conf_path+"/"+subject
            if os.path.exists(project_dir):
                print("目录："+project_dir+"   已经存在,删除重建")
                shutil.rmtree(project_dir)

            os.makedirs(project_dir)
            print("目录："+project_dir+"   创建成功")
            # done:生成 gen_sql.sql 文件


            with open(project_dir+'/gen_sql.sql','w+') as temp:
                temp.write("INSERT OVERWRITE LOCAL DIRECTORY '" + project_dir+"/data' ROW FORMAT DELIMITED FIELDS TERMINATED BY ','\n" )
                temp.write(sql_str)
            # Todo:生成 conf.ini 文件
            with open(project_dir+'/conf.ini','w+') as temp:
                temp.write("[mail]\n" )
                temp.write("subject="+subject+"\n")
                temp.write("receiver="+receiver+"\n")
                temp.write("fields_comment="+fields_comment+"\n")
                temp.write("[notifier]\n")
                temp.write("productorTel="+productorTel+"\n")
                temp.write("productorName="+productorName+"\n")
                temp.write("crontab="+crontab+"\n")
                temp.write("insert_time="+insert_time+"\n")
            # done:复制可执行脚本
            dstfile = project_dir+'/send_email.sh'
            srcfile = project_dir+'/../../send_email.sh'
            shutil.copyfile(srcfile,dstfile)
            # done:生成crotab并报群里
            crontab_info = " 00  00 * * * source /etc/profile; bash " + dstfile
             # curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=369a3660-993b-437d-a78c-bcf84e442aaf' \
            #  curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=892af622-b2cc-41a3-897f-f59ee52bc5fc' \
            reportMsgCommand = """
             curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=77463d0b-b2bb-4955-802b-c9ff04fa2df6' \
               -H 'Content-Type: application/json' \
               -d '
               {{
                    "msgtype": "text",
                    "text": {{
                        "content": "请配置调度 \n时间:{0} \n语句:{1}",
                        "mentioned_mobile_list":["18616272395"]
                    }}
               }}'
             """.format(crontab,crontab_info)
            print ("reportMsgCommand:"+reportMsgCommand)
            if status == '0': #0为插入，2为更新；更新不用配置调度
                output = os.popen(reportMsgCommand)
                print("output:" +str(output))

if __name__ == '__main__':
    ReadMysql().getdata()
