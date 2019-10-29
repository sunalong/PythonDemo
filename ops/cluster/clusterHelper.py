# -*- coding: utf-8 -*-

# 有数据，且波动在10%以内，将信息插入到mysql并提示
# 无数据或波动大于10%，将信息插入到mysql并@相关人报警
# import datetime
import time

from decimal import Decimal

from com.itcode.utils.MysqlUtils import MysqlUtils
from com.itcode.utils.WechartRobot import WechartRobot

start_time = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))

class ClusterHelper:

    def judge(self):
        # 判断mysql的结果,根据结果来报警或提示
        # group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        # 按序号 将各表ETL情况发送到一个新的正常提示预警群里
        sql = self.create_judge_sql()

        print("执行脚本为：",sql)
        retLists = MysqlUtils().query(sql)
        i=0
        for item in retLists:
            print(i," type:",type(item),"  item:",item)
            if item[4]>=0.75:
                subret = self.ret_str(item[0],item)
                resultMsg="集群："+item[1]+"\n"+subret+"\n时间："+item[10]+"\n"
                # print("Todo:报警机器人说:\n",resultMsg)
                if item[0] in('disk','memory','network','process','load'):
                    print("Todo:报警机器人说:\n", resultMsg)
                    WechartRobot().alert(group=WechartRobot.cluster_usable_group,msg=resultMsg)
            i+=1

    def ret_str(self, groups,item):
        numbers = {
            'disk': "剩余存储空间：" + str(item[5]) + " GB\n整体空间："+str(item[3])+" GB\n占比："+str(Decimal(item[4]*100).quantize(Decimal('0.00')))+"%",
            'load': "负载：" + str(item[6]),
            'memory': "内存使用：" + str(item[7]) + " GB\n整体内存："+str(item[3])+" GB\n占比："+str(Decimal(item[4]*100).quantize(Decimal('0.00')))+"%",
            'network': "网络吞吐：" + str(item[8]) + " MB/sec\n网卡："+str(item[3])+"MB\n占比："+str(Decimal(item[4]*100).quantize(Decimal('0.00')))+"%",
            'process': "进程数：" + str(item[9])+"\n整体进程数："+str(item[3])
        }
        subret= numbers.get(groups)
        # print("subret:",subret)
        return subret

    def create_judge_sql(self):
        "根据表名创建查询判断语句"
        judge_sql_pattern = """

with item as (
  select *
  , row_number() over(partition by id order by insert_time desc) as rn
  from ganglia_cluster
  where `group` in ('disk','memory','network','process','load')
  and metric not in('pkts_in','pkts_out','load_fifteen','load_five','mem_shared')
  and substring(insert_time,1,10)='{0}'
)
,base as(
  select `group`,cluster,metric,sum(value) as value_total,insert_time
  ,count(distinct host) as host_count
  from item
  where rn=1
  -- and cluster = 'presto_cluster'
  group by `group`,cluster,metric,insert_time
)
,detail as (
  select `group`,cluster,metric,value_total
  , host_count
  , cast(sum(if(metric='disk_free',value_total,0)) over (partition by cluster) as decimal(38,0))as disk_free_value
  , cast(sum(if(metric='load_one',value_total,0)) over (partition by cluster) as decimal(38,0))as load_one_value
  , cast(sum(case when metric='mem_total' then value_total when metric in('mem_free','mem_cached','mem_buffers') then -value_total else 0 end) over (partition by cluster) as decimal(38,0)) as mem_use_value 
  , cast(sum(if(metric in('bytes_in','bytes_out'),value_total,0)) over (partition by cluster) as decimal(38,0))as net_flow_value 
  , cast(sum(if(metric='proc_run',value_total,0)) over (partition by cluster) as decimal(38,0))as proc_run_value
  , insert_time
  from base
)
,calc_judge as(
  select `group`,cluster
  , metric
  , cast(
     case when metric = 'mem_total' then value_total/1024/1024
 	      when metric = 'bytes_in' then 1000*host_count
     else value_total end as decimal(38,0)) as value_total
  , cast(
     case when metric ='disk_total' then 1-disk_free_value/value_total 
 	     when metric = 'load_one' then value_total/100
 	     when metric = 'mem_total' then mem_use_value/value_total
 	     when metric = 'bytes_in' then net_flow_value/1024/1024/1000/host_count
 	     when metric = 'proc_total' then proc_run_value/value_total
     else 0 end as decimal(38,4)) as judge_value
  , disk_free_value  -- GB
  , load_one_value
  , cast(mem_use_value/1024/1024 as decimal(38,0)) as mem_use_value  -- GB
  , cast(net_flow_value/1024/1024 as decimal(38,0)) as net_flow_value  -- MB
  , proc_run_value
  , insert_time
  from detail
  where metric in('disk_total','load_one','mem_total','bytes_in','proc_total')
)
select *
from calc_judge
          """.format(start_time[0:10])
        return judge_sql_pattern

if __name__ == '__main__':
    ClusterHelper().judge()
    pass
