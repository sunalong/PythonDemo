# -*- coding: utf-8 -*-
import datetime
import os
import sys

from com.itcode.utils.MysqlUtils import MysqlUtils


class ReadMysql:
    def __init__(self):
        for i in range(0, len(sys.argv)):
            print(str(i) + ": " + sys.argv[i])
        self.conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))
        print("conf_path:" + self.conf_path)
        self.curr_date = datetime.datetime.now().strftime('%Y-%m-%d')
        self.execSql = "select mysql_host,mysql_port,mysql_db_name,mysql_table_name,primary_key,order_field,mr_count,username,productor,status,insert_time from data_governance.auto_extract_data where status<>1"

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

    def createProject(self, item):
        mysql_host = str(item[0])
        mysql_port = str(item[1])
        mysql_db_name = str(item[2])
        mysql_table_name = str(item[3])
        primary_key = str(item[4])
        order_field = str(item[5])
        mr_count = str(item[6])
        username = str(item[7])
        productor = str(item[8])
        status = str(item[9])

        update_sql = """
        update data_governance.auto_extract_data set status=1 where mysql_db_name='{0}' and mysql_table_name='{1}'
        """.format(mysql_db_name, mysql_table_name)
        if status != "1":
            print("fuck:" + update_sql)
            retLists = MysqlUtils().insert_single(update_sql)
            print("改变数据状态：" + str(retLists))
            # Todo:生成 conf.ini 文件
            with open(self.conf_path + '/conf.ini', 'w+') as temp:
                temp.write("[db]\n")
                temp.write("mysql_host=" + mysql_host + "\n")
                temp.write("mysql_port=" + mysql_port + "\n")
                temp.write("mysql_db_name=" + mysql_db_name + "\n")
                temp.write("mysql_table_name=" + mysql_table_name + "\n")
                temp.write("primary_key=" + primary_key + "\n")
                temp.write("order_field=" + order_field + "\n")
                temp.write("mr_count=" + mr_count + "\n")
                temp.write("username=" + username + "\n")
                temp.write("productor=" + productor + "\n")
                temp.write("status=" + status + "\n")
            # done:复制可执行脚本
            # "00 01 * * * source /etc/profile; bash /data/app/dev/data_biz/etl/comment_db/yh_product_comment_tag_detail/crontab_ods_comment_db__yh_product_comment_tag_detail.sh"
            dstfile = '/data/app/dev/data_biz/etl/'+mysql_db_name+'/'+mysql_table_name+'_view/crontab_dwd_'+mysql_db_name+'__'+mysql_table_name+'.sh'
            # done:生成crotab并报群里
            crontab_info = " 00 00 * * * source /etc/profile; bash " + dstfile
             # curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=369a3660-993b-437d-a78c-bcf84e442aaf' \
            # curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=892af622-b2cc-41a3-897f-f59ee52bc5fc' \
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
             """.format('查看ganglia空闲时间', crontab_info)
            print("reportMsgCommand:" + reportMsgCommand)
            if status == '0':  # 0为插入，2为更新；更新不用配置调度
                # output = os.popen(reportMsgCommand)
                # print("output:" + str(output))
                pass


if __name__ == '__main__':
    ReadMysql().getdata()
