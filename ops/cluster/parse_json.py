# -*- coding: utf-8 -*-
import urllib.request
import json
import time
from com.itcode.utils.MysqlUtils import MysqlUtils

class Parse_json:
    def collect_insert(self):
        # url = 'http://10.10.2.156:8080/ganglia/api/v2/metrics?&environment=all&cluster=hadoop_yarn_cluster&host=uhadoop-mzwc2w-task19&grid=unspecified&metric=part_max_used'
        # url = 'http://10.10.2.156:8080/ganglia/api/v2/metrics?&environment=all&cluster=hadoop_yarn_cluster&grid=unspecified&metric=part_max_used'
        start_time = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        url = 'http://10.10.2.156:8080/ganglia/api/v2/metrics'
        html = urllib.request.urlopen(url).read()

        # 获取ganglia 的metrics json数据
        jsonobj = json.loads(html)
        metrics_list = jsonobj['metrics']
        k_v_list = []

        useful_set=set(['group','grid','cluster','host','metric','value','units','id','sampleTime'])

        # 解析 json 数据，添加到list中
        for metrics_dict in metrics_list:
            k_v_dict={}
            for k, v in metrics_dict.items():
                if(k in useful_set):
                    k_v_dict[k]=v
            k_v_list.append(k_v_dict)

        # 将list中的数据放到插入语句中，批次插入到mysql
        i=1
        insert_str = "insert into data_governance.ganglia_cluster(`group`,`grid`,`cluster`,`host`,`metric`,`value`,`units`,`id`,`sampleTime`,insert_time) VALUES\n"
        for item in k_v_list:
            if i<k_v_list.__len__():
                insert_str+="('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}'),".format(item['group'],item['grid'],item['cluster'],item['host'],item['metric'],item['value'],item['units'],item['id'],item['sampleTime'],start_time)
            else:
                insert_str += "('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}');".format(item['group'], item['grid'], item['cluster'], item['host'], item['metric'], item['value'],item['units'], item['id'], item['sampleTime'],start_time)
            i += 1

        print(i,insert_str)
        MysqlUtils().insert_single(insert_str)

        end_time = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))

        print("start_time:",start_time)
        print("end_time  :",end_time)


if __name__ == '__main__':
    #MonitorDwd().insertToMysql(MonitorDwdHelper.current_table)
    #MonitorDwd().judge(MonitorDwdHelper.current_table)
    # command()
    Parse_json().collect_insert()