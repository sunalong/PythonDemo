
1.将时间戳转化为日期格式
  select from_unixtime(1560792029110/1000);
  2019-06-18 01:20:29
  截取时间
  select substring(from_unixtime(1560792029110/1000),1,10);
  2019-06-18



2.整个数据库中只保留三天的数据
  select count(*),substring(from_unixtime(start_time/1000),1,10) as sdt
  from data_governance.dwd_yarn_application_info
  group by sdt
  order by substring(from_unixtime(start_time/1000),1,10)


  count(*)|sdt       |
  --------|----------|
         3|2019-04-18|
         1|2019-06-16|
      1186|2019-06-17|
      3855|2019-06-18|
      3595|2019-06-19|



3.查询0点到3点的大任务
  select app_id
  , app_type
  , user
  , queue
  , from_unixtime(start_time/1000) as start_time
  , from_unixtime(finish_time/1000) as finish_time
  , mem_value
  , vcore_value
  , progress
  , state
  , final_state
  , tracking_url
  , rpc_port
  , am_host
  from data_governance.dwd_yarn_application_info
  where substring(from_unixtime(start_time/1000),1,13)  between  '2019-06-18 00' and '2019-06-18 03'
  order by mem_value DESC,vcore_value DESC


app_id                         |app_type |user |queue     |start_time         |finish_time        |mem_value|vcore_value|progress|state   |final_state|tracking_url                                                              |rpc_port|am_host              |
-------------------------------|---------|-----|----------|-------------------|-------------------|---------|-----------|--------|--------|-----------|--------------------------------------------------------------------------|--------|---------------------|
application_1559977101983_42701|MAPREDUCE|sqoop|root.sqoop|2019-06-18 01:16:00|2019-06-18 01:34:24|845838893|     206709|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42701|35066   |uhadoop-mzwc2w-task44|
application_1559977101983_42491|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:42:06|2019-06-18 01:11:20|647816614|      79322|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42491|47781   |uhadoop-mzwc2w-task27|
application_1559977101983_42507|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:42:53|2019-06-18 01:10:45|590823743|      72335|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42507|56800   |uhadoop-mzwc2w-task3 |
application_1559977101983_43222|MAPREDUCE|sqoop|root.sqoop|2019-06-18 03:35:17|2019-06-18 03:49:03|382151816|      24003|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_43222|39791   |uhadoop-mzwc2w-task54|
application_1559977101983_42871|MAPREDUCE|sqoop|root.sqoop|2019-06-18 01:51:39|2019-06-18 02:05:09|301093187|      73166|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42871|40548   |uhadoop-mzwc2w-task54|
application_1559977101983_42372|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:28:56|2019-06-18 00:39:56|221903050|      27319|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42372|43306   |uhadoop-mzwc2w-task12|
application_1559977101983_42307|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:10:45|2019-06-18 00:18:07|219974333|      81054|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42307|53975   |uhadoop-mzwc2w-task48|
application_1559977101983_42332|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:19:00|2019-06-18 00:33:42|214918085|      26819|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42332|42637   |uhadoop-mzwc2w-task52|
application_1559977101983_43254|MAPREDUCE|sqoop|root.sqoop|2019-06-18 03:51:03|2019-06-18 03:59:01|212308674|      13333|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_43254|33113   |uhadoop-mzwc2w-task48|
application_1559977101983_42292|MAPREDUCE|sqoop|root.sqoop|2019-06-18 00:05:33|2019-06-18 00:12:52|207352540|      85268|100%    |FINISHED|SUCCEEDED  |http://uhadoop-mzwc2w-master2:19888/jobhistory/job/job_1559977101983_42292|40224   |uhadoop-mzwc2w-task28|


4.查询峰值application:


  select app_id
  , app_name
  , app_type
  , user
  , queue
  , from_unixtime(start_time/1000) as start_time
  , from_unixtime(finish_time/1000) as finish_time
  , mem_value
  , vcore_value
  , progress
  , state
  , final_state
  , tracking_url
  , rpc_port
  , am_host
  from data_governance.dwd_yarn_application_info
--   where substring(from_unixtime(start_time/1000),1,16)  between  '2019-06-23 01:40' and '2019-06-23 02:00'
  where substring(from_unixtime(finish_time/1000),1,16)  between  '2019-06-24 01:50' and '2019-06-24 02:05'
--   and app_name='dwd.dwd_site_inventory_center__site_inventory_log'
  order by mem_value DESC,vcore_value DESC


5.查询每十分钟资源消耗统计
  用以查看峰谷值,从而移动任务的调度时间
  select
  concat(substring(from_unixtime(finish_time/1000),1,15),'x') as ten_min
  , sum(mem_value) as mem_value_total
  , sum(vcore_value) as vcore_value_total
  from data_governance.dwd_yarn_application_info
  where substring(from_unixtime(finish_time/1000),1,13)  between  '2019-06-25 01' and '2019-06-25 03'
  --   where substring(from_unixtime(finish_time/1000),1,16)  between  '2019-06-25 01:20' and '2019-06-25 01:35'
  group by substring(from_unixtime(finish_time/1000),1,15)
  order by substring(from_unixtime(finish_time/1000),1,15)


  ten_min         |mem_value_total|vcore_value_total|
  ----------------|---------------|-----------------|
  2019-06-25 01:0x|    395,577,658|           78,564|
  2019-06-25 01:1x|    133,137,549|           43,710|
  2019-06-25 01:2x|     59,226,480|           26,862|
  2019-06-25 01:3x|  1,028,293,685|          296,731|
  2019-06-25 01:4x|     59,020,187|           31,249|
  2019-06-25 01:5x|      5,328,568|            2,259|
  2019-06-25 02:0x|     16,648,247|            7,773|
  2019-06-25 02:1x|    341,839,742|           83,464|
  2019-06-25 02:2x|    259,568,463|           66,806|
  2019-06-25 02:3x|    312,196,311|          131,186|
  2019-06-25 02:4x|    238,715,810|           44,182|
  2019-06-25 02:5x|    425,146,914|           63,698|
  2019-06-25 03:0x|    219,198,659|           40,673|
  2019-06-25 03:1x|    213,798,858|           47,962|
  2019-06-25 03:2x|    215,284,536|           89,494|
  2019-06-25 03:3x|    633,436,901|          192,405|
  2019-06-25 03:4x|    168,896,028|           35,068|
  2019-06-25 03:5x|    508,681,149|           38,343|

使用说明:
  01:3x有个波峰,由4查到是其中一个任务资源占用为:799,330,657	195,271
  根据这个查询结果,可将其移到到01:5x来执行


6.查询每个小时top10的大任务
  select *
  from (select substring(from_unixtime(finish_time/1000),12,2) as hh
    , app_id
    , from_unixtime(start_time/1000) as start_time
    , from_unixtime(finish_time/1000) as finish_time
    , mem_value
    , vcore_value
    , row_number() over(partition by substring(from_unixtime(finish_time/1000),12,2) order by mem_value desc) rn
    from data_governance.dwd_yarn_application_info as a
    where substring(insert_time,1,10)='2019-06-26'
  )as a
  where a.rn<=10


7.指定任务历史耗时查询:
    select app_id
    , app_type
    , user
    , queue
    , timediff(from_unixtime(finish_time/1000),from_unixtime(start_time/1000))as done_time
    , from_unixtime(start_time/1000) as start_time
    , from_unixtime(finish_time/1000) as finish_time
    , mem_value
    , vcore_value
    , progress
    , state
    , final_state
    , tracking_url
    , rpc_port
    , am_host
    from data_governance.dwd_yarn_application_info
    where substring(from_unixtime(start_time/1000),1,10)  between  '2019-09-18' and '2019-09-28'
      and app_name = 'dwd.dwd_order_db__t_trade_order_item_inc'
    order by start_time
