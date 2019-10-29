# -*- coding: utf-8 -*-

#  查询dwd层重要的订单七张表，
# 有数据，且波动在10%以内，将信息插入到mysql并提示
# 无数据或波动大于10%，将信息插入到mysql并@相关人报警
# Todo:查询失败的处理
# dwd.dwd_order_db__t_trade_order_item
# import datetime
import datetime
import socket

import os

import sys

from com.itcode.utils.MysqlUtils import MysqlUtils
from com.itcode.utils.PrestoUtils import PrestoUtils
from com.itcode.utils.WechartRobot import WechartRobot
from com.itcode.utils.date_tool import get_pritition_date


class MonitorDwdHelper:

    # current_table = "dwd_order_db__t_trade_order_item"
    # current_table = "dwd_mms_msm_center__msm_bom_allocation"
    # current_table = "dwd_mms_msm_center__msm_bom_raw_material"
    # current_table = "dwd_yh_pay_center__yh_recharge_bill"
    current_table = "dwd_promotion_db__t_bargain"

    def __init__(self):
        self.curr_date=datetime.datetime.now().strftime('%Y-%m-%d')
        self.countSql = "select count(*) as record_cnt from dwd.dwd_order_db__t_trade_order_item where substring(last_updated_at,1,10)='{0}'".format(self.curr_date)

        self.today = datetime.datetime.now()
        self.delta = datetime.timedelta(days=1)
        self.end_date = self.today.strftime('%Y%m%d')
        self.start_date = (self.today - self.delta).strftime('%Y%m%d')
        self.conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))
        self.params = []
        self.get_table_info()

    def get_table_info(self):
        conf_file = '/'.join((self.conf_path, "dwd_all_monitor/special_tab.cfg"))
        with open(conf_file, 'r') as fd:
            lines = fd.readlines()
            for line in lines:
                line = line.strip()
                if len(line) != 0:
                    self.params.append(line.split())

    def count_cnt(self):
        self.record_cnt=PrestoUtils().count(self.countSql)
        return self.record_cnt

    def insertToMysql(self,current_table):
        # 将查询的结果插入到mysql中
        db_table = query_dg_check_config(current_table)
        # for db_table in db_tableList:
        item_pross(db_table,self.end_date)
        # pass

    def judge(self,current_table):
        # 特殊表的处理： 如果当时时间小于本表的指定的更新时间，不必执行下面的判断
        special_tab_judge(current_table,self.params)
        # 判断mysql的结果,根据结果来报警或提示
        # group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        # 按序号 将各表ETL情况发送到一个新的正常提示预警群里
        sql = self.create_judge_sql(current_table)

        print("执行脚本为：",sql)
        retLists = MysqlUtils().query(sql)
        resultMsg=""
        for item in retLists:
            print(str(item)+"\n")
            resultMsg=resultMsg+"当前表："+str(item[0])+"\n今日数据："+str(item[1])+"\n昨日数据："+str(item[2])+"\n环比昨日："+str(item[4])+"\n主机名："+socket.gethostname()+"\nmax("+str(item[5])+")："+str(item[6])+"\n最近一次调度完成时间："+str(item[7])+"\n"

            if (abs(item[3])>10) | (item[3]==0) :
            # elif (abs(item[3])>10) :
                print("触达波动：",resultMsg)
                WechartRobot().alert(group=WechartRobot.data_exception_group,msg=resultMsg)

    def create_judge_sql(self,current_table):
        "根据表名创建查询判断语句"
        judge_sql_pattern = """
              with row_item as(
                select a.hive_table_name
                ,a.records
                ,lag(a.records) over(partition by a.hive_table_name order by a.check_date) as yesterday_records
                ,a.max_field
                ,a.max_value
                ,cast(b.last_crontab_time as char) as last_crontab_time
                from data_governance.dg_check_count as a
                left join data_governance.dim_dwd_table_info as b on b.hive_table_name = a.hive_table_name
                where a.hive_table_name = '{0}'
                  and a.check_date in('{1}','{2}')
              )
              select hive_table_name
              ,records
              ,yesterday_records
              ,convert((if(yesterday_records=0,0,records/yesterday_records) -1)*100,decimal(18,2)) as tty_decim
              ,concat(convert((if(yesterday_records=0,0,records/yesterday_records) -1)*100,decimal(18,2)),'%') as tty_str
              ,max_field
              ,max_value
              ,last_crontab_time
              from row_item
              where yesterday_records is not null
          """.format(current_table, self.start_date, self.end_date)
        return judge_sql_pattern

def special_tab_judge(current_table,params):
    """特殊表的处理： 如果当时时间小于本表的指定的更新时间，不必执行下面的判断"""
    print(current_table)
    for line in params:
        # 防止类似行内容为"::00 "的干扰
        if len(line) < 2:
            print("fuck line len:", len(line))
            continue
        schedule_time = line[0]
        table_name = line[1]
        curr_date = datetime.datetime.now().strftime('%Y-%m-%d')
        dt_string = curr_date + " " + schedule_time+":00"
        schedule_datetime = datetime.datetime.strptime(dt_string, "%Y-%m-%d %H:%M:%S")

        curr_time = datetime.datetime.now()
        if table_name == current_table:
            if curr_time < schedule_datetime:
                print("时间未到,暂不预警：\ncurr_time:",curr_time,"\nschedule_datetime：",schedule_datetime,"\ntable_name:",table_name)
                sys.exit(0)


def save_to_check(ret_dict):
    "将数据保存到mysql check表中"
    insert_sql_str = """
        REPLACE INTO data_governance.dg_check_count(
        `hive_db_name`, 
        `hive_table_name`, 
        `records`, 
        `check_date`, 
        `table_status`, 
        `max_field`, 
        `max_value`, 
        `start_time`, 
        `end_time`, 
        `check_status`,  
        `partition_field`,
        `partition_field_value`,
        `catalog_value`)
        VALUES ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', {9},'{10}','{11}','{12}')
        """.format(
                   ret_dict['hive_db_name'],
                   ret_dict['hive_table_name'],
                   ret_dict['records'],
                   ret_dict['check_date'],
                   ret_dict['table_status'],
                   ret_dict['max_field'],
                   ret_dict['max_value'],
                   ret_dict['start_time'],
                   ret_dict['end_time'],
                   ret_dict['check_status'],
                   ret_dict['partition_field'],
                   ret_dict['partition_field_value'],
                    ret_dict['catalog_value'])
    print("insert_sql_str:",insert_sql_str)
    ret = MysqlUtils().insert_single(insert_sql_str)
    print("插入返回结果：",ret)
    return ret


def item_pross(db_table,check_date):
    # print("************** {0}".format(db_table))
    hive_count_dict = create_query_sql(db_table)
    # print("hive_count_dict:", hive_count_dict)

    check_status_dict = get_start_end_time(db=db_table['hive_db_name'], table=db_table['hive_table_name'])
    print("check_status_dict:", check_status_dict)

    ret_dict = create_ret_dict(check_date, check_status_dict, db_table, hive_count_dict)
    # print("ret_dict22:",ret_dict)
    save_to_check(ret_dict)
    # with self.main_thread_lock:
    #    save_to_check(ret_dict)


def create_ret_dict(check_date, check_status_dict, db_table, hive_count_dict):
    "创建返回值字段组成的map"
    ret_dict = {}
    ret_dict['check_status'] = '0'
    ret_dict['check_date'] = check_date
    ret_dict['max_field'] = db_table['max_field']
    ret_dict['hive_db_name'] = db_table['hive_db_name']
    ret_dict['hive_table_name'] = db_table['hive_table_name']
    ret_dict['start_time'] = ""
    ret_dict['end_time'] = ""
    ret_dict['table_status'] = '-999'
    ret_dict['records'] = ""
    ret_dict['max_value'] = ""
    ret_dict['partition_field'] = db_table['partition_field']
    ret_dict['catalog_value'] = db_table['catalog_value']
    if ret_dict['partition_field'] is None:
        ret_dict['partition_field'] = ""
    if ret_dict['max_field'] is None:
        ret_dict['max_field'] = ""
    if ret_dict['max_value'] is None:
        ret_dict['max_value'] = ""
    if hive_count_dict:
        ret_dict['records'] = hive_count_dict['records']
        ret_dict['max_value'] = hive_count_dict['max_value']
        ret_dict['partition_field_value'] = hive_count_dict['partition_field_value']
        ret_dict['catalog_value'] = hive_count_dict['catalog_value']
    else:
        ret_dict['check_status'] = '1'
    if check_status_dict:
        ret_dict['start_time'] = check_status_dict['start_time']
        ret_dict['end_time'] = check_status_dict['end_time']
        ret_dict['table_status'] = check_status_dict['table_status']
    else:
        ret_dict['check_status'] = '2'
    if hive_count_dict and check_status_dict:
        pass
    else:
        ret_dict['check_status'] = '3'
    return ret_dict


def query_dg_check_config(current_table):
    "在监控表中查询当前表的配置信息：是否分区、分区字段类型"
    db_table_dict = {}
    query_sql="""
      select hive_table_name
      , max_field
      , last_crontab_time
      , partition_field
      from data_governance.dim_dwd_table_info 
      WHERE hive_table_name='{0}'
      """.format(current_table)
    print("querysql:",query_sql)
    ret = MysqlUtils().query(query_sql)
    for line in ret:
        print("line:",line)

        db_table_dict['hive_table_name'] = line[0]
        db_table_dict['max_field'] = line[1]
        db_table_dict['last_crontab_time'] = line[2]
        db_table_dict['partition_field'] = line[3]
    return db_table_dict


def create_query_sql(db_table):
    "使用presto查询hive库中本表的当天记录数与更新时间"
    partition_field=db_table['partition_field']
    # 如果没有分区字段，查询全表数据
    if db_table['partition_field'] == '':
        sql = "select count(1) as records, 0 as max_value from dwd.{0}".format(db_table['hive_table_name'])
    else:
        sql = "select count(1) as records, max({0})       from dwd.{1} where {3} = {4}".format(partition_field, db_table['hive_table_name'], partition_field,get_pritition_date(partition_field))
    print("create:", sql)
    ret = PrestoUtils().query(sql)
    print("create ret:",ret)





    if str(db_table['is_partition']) == "1":
        partition_flag = db_table['partition_flag']
        partition_field_value = get_pritition_date(partition_flag)
    else:
        partition_field_value = ""

    db = db_table['hive_db_name']
    table = db_table['hive_table_name']
    max_field = db_table['max_field']
    is_partiton = db_table['is_partition']
    partition_field = db_table['partition_field']
    partition_field_type = db_table['partition_field_type']
    partition_field_value = partition_field_value
    catalog_value = db_table['catalog_value']

    # 对于部分表 如 dwd_b2c_db__yh_lucky_draw_activity catalog_value可能为 '  '
    if catalog_value is None or catalog_value == "" or catalog_value.strip() == '':
        catalog_value = "hive"

    # print("is_partiton : {}".format(is_partiton))
    if is_partiton == 1:
        if partition_field_type == "string":
            if max_field is None or max_field == "":
                sql = "select count(1) as records, 0 as max_value from {0}.{1}.{2} where {3} = '{4}' " \
                    .format(catalog_value, db, table, partition_field, partition_field_value)
            else:
                sql = "select count(1) as records, max({0}) from {1}.{2}.{3} where {4} = '{5}' " \
                    .format(max_field, catalog_value, db, table, partition_field, partition_field_value)
        else:
            if max_field is None or max_field == "":
                sql = "select count(1) as records,  0 as max_value from {0}.{1}.{2} where {3} = {4} " \
                    .format(catalog_value, db, table, partition_field, partition_field_value)
            else:
                sql = "select count(1) as records, max({0}) from {1}.{2}.{3} where {4} = {5} " \
                    .format(max_field, catalog_value, db, table, partition_field, partition_field_value)
    else:
        if max_field is None or max_field == "":
            sql = "select count(1) as records, 0 as max_value from {0}.{1}.{2}".format(catalog_value, db, table)
        else:
            sql = "select count(1) as records, max({0}) from {1}.{2}.{3}".format(max_field, catalog_value, db, table)
    print("create:",sql)
    ret = PrestoUtils().query(sql)
    # print("create ret:",ret)
    ret_dict = {}
    # print("ret['itemList'][0][0]:",ret['itemList'][0][0])
    # print("ret['itemList'][0][1]:",ret['itemList'][0][1])
    if ret:
        ret_dict['records'] = str(ret['itemList'][0][0])
        ret_dict['max_value'] = str(ret['itemList'][0][1])

    ret_dict['partition_field_value'] = partition_field_value
    ret_dict['catalog_value'] = catalog_value
    # print("ret_dict111:", ret_dict)
    return ret_dict

def get_start_end_time(db, table):
    query_sql_str="""
        select a.start_time,a.end_time,a.`status`  
        from data_governance.t_check_hive_etl a 
        where a.db='{0}' and a.`table` = '{1}'
        """.format(db, table)
    # print("get_start_end_time:",query_sql_str)
    ret = MysqlUtils().query(query_sql_str)
    # print("retlll:",ret)
    ret_dict = {}
    # print(ret[0][0], ret[0][1], ret[0][2])
    if ret:
        ret_dict['start_time'] = str(ret[0][0])
        ret_dict['end_time'] = str(ret[0][1])
        ret_dict['table_status'] = ret[0][2]
    print(ret_dict)
    return ret_dict

if __name__ == '__main__':
    # cnt=MonitorDwdHelper().count_cnt()
    # print("record_cnt:",cnt)
    # ret = MonitorDwdHelper().getDataFromMysql(MonitorDwdHelper.dwd_sql)
    # print("静态变量：",WechartRobot.failture_group)

    MonitorDwdHelper().insertToMysql(MonitorDwdHelper.current_table)
    # MonitorDwdHelper().judge(MonitorDwdHelper.current_table)
    # MonitorDwdHelper().judge(MonitorDwdHelper.judge_sql_pattern)
    # today = datetime.datetime.now()
    # delta = datetime.timedelta(days=1)
    # end_date = today.strftime('%Y%m%d')
    # start_date =(today-delta).strftime('%Y%m%d')
    #
    # print("start_date:",start_date)
    # print("end_date:",end_date)

    pass
