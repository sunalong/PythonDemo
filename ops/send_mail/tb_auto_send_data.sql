drop table data_governance.auto_send_email;
CREATE TABLE data_governance.auto_send_email (
  subject varchar(100) NOT NULL COMMENT '邮件名称，同生成的文件名称',
  sql_str mediumtext,
  fields_comment text COMMENT '输出字段的中文名称，以逗号分隔',
  receiver text COMMENT '收件人邮箱地址，以逗号分隔',
  productorTel varchar(100) DEFAULT NULL COMMENT '失败后发送群通知的产品人员的手机号',
  productorName varchar(100) DEFAULT NULL COMMENT '产品人员姓名',
  crontab text COMMENT '调度周期',
  status int(1) NOT NULL DEFAULT '0' COMMENT '任务状态，0 数据插入默认为0，1 已经配置成功，2 更新',
  insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据插入时间',
  PRIMARY KEY (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='执行sql,将结果 自动发送csv压缩文件给指定邮箱'




delete from data_governance.auto_send_email where subject = '任务名称'
alter table data_governance.auto_send_email  modify column sql_str mediumtext
alter table data_governance.auto_send_email  add  productorName varchar(100) comment '产品人员姓名'
update data_governance.auto_send_email set status=2


INSERT into data_governance.auto_send_email (subject,sql_str,fields_comment,receiver,producter,crontab)
VALUES
="('"&A1&"','sql_str','"&C1&"','"&D1&"','"&E1&"','"&F1&"'),"

INSERT into data_governance.auto_send_email (subject,sql_str,fields_comment,receiver,producter,crontab)
VALUES
('云超注册转化数据','
select

regexp_replace(date_add(current_date,-7),''-'','''')
,regexp_replace(date_add(current_date,-1),''-'','''')
,c.province_name
,count(1)
,count(g.dim_member_id)
,cast(count(g.dim_member_id) as double) / cast(count(1) as double)

from dim.dim_member_information as a

left join dim.dim_shop as c
on a.shop_id = c.dim_shop_id

left join
    (--云超线上下单用户
    select   e.dim_member_id

    from dw.dwb_fct_order as e
    left join dim.dim_shop as f
    on e.dim_shop_id = f.dim_shop_id

    where
    e.sdt > ''20190301'' --分区键
    and cast(e.dim_date_id as double) between regexp_replace(date_add(current_date,-7),''-'','''')
                                          and
                                              regexp_replace(date_add(current_date,-1),''-'','''') --下单时间
    and e.is_root = 1
    and e.pay_at <> ''''
    and e.dim_channel_id in (''1'',''6'',''7'',''13'') --微信小程序，app
    and e.dim_ordertype_id in (''1'',''2'') --配送,自提
    and f.seller_type_id in (''1'',''3'',''4'',''5'') --绿标店，精标店，红标店，红标优选店

    group by e.dim_member_id
    ) as g
on a.member_id = g.dim_member_id


where
a.sdt = regexp_replace(date_add(current_date,-1),''-'','''') --dim_member_information必须带时间分区
and cast(regexp_replace(a.signup_time,''-'','''') as double) between regexp_replace(date_add(current_date,-7),''-'','''')
                                                         and
                                                         regexp_replace(date_add(current_date,-1),''-'','''') --注册时间
and a.member_account_type <> 3
and c.seller_type_id in (''1'',''3'',''4'',''5'') --绿标店，精标店，红标店，红标优选店

group by c.province_name

order by c.province_name','起始周期,结束周期,省份,本周新注册会员,本周新注册会员中云超线上订单会员,转化率','80831324@yonghui.cn,80776301@yonghui.cn','13301996030,18616272395','每周一'),
('厦门沉默用户openID','select a.city_name
       ,b.open_id
       ,type
from
(select dim_member_id,city_name,type
from temp.adl_userlifecycle
where sdt= regexp_replace(date_add(current_date,-5),''-'','''')
and city_name = ''厦门市''
and type in (''1'',''2'',''4'')
group by dim_member_id,city_name,type
order by dim_member_id,city_name,type) a
left join dwd.dwd_member_center__yh_member_wechat b
on a.dim_member_id = b.member_id
group by a.city_name,b.open_id,type','城市名称,open_id,用户类型1无效2流失4沉睡','80831324@yonghui.cn,80824783@yonghui.cn','13301996030,18616272395','每周二'),
('厦门超过两单用户openID','select a.receiver_city
,a.member_id
,b.open_id
,a.orders
from
(select receiver_city,member_id,count(distinct root_order_id) as orders
from dm_pw.fct_preposition_order
where parent_order_id = ''''
and sdt between regexp_replace(date_add(current_date,-7),''-'','''')
and regexp_replace(date_add(current_date,-1),''-'','''') -- 上周二到这周一
and receiver_city = ''厦门''
group by receiver_city,member_id
having count(distinct root_order_id) >= 2) a
left join dwd.dwd_member_center__yh_member_wechat b
on a.member_id = b.member_id
where b.open_id is not null
group by a.receiver_city,a.member_id,b.open_id,a.orders','城市,用户ID,open_id,下单数量','80831324@yonghui.cn,80824783@yonghui.cn','13301996030,18616272395','每周二'),
('厦门当周新购用户openID','select
a.member_id
,b.open_id
,a.pay_date
from dm.dm_yhdj_new_member a
left join dwd.dwd_member_center__yh_member_wechat b
on a.member_id = b.member_id
join dm_pw.fct_preposition_order c
on a.order_id = c.order_id
where c.receiver_city = ''厦门''
and a.pay_date between date_add(current_date,-7) and date_add(current_date,-1) -- 上周二到这周一
and b.open_id is not null
group by a.member_id,b.open_id,a.pay_date','用户ID,open_id,首单时间','80831324@yonghui.cn,80824783@yonghui.cn','13301996030,18616272395','每周二'),
('到家业态生日数据','select

a.dim_member_id
,a.yhdj_fb_city_code
,a.yhdj_fb_city_name
,a.yhdj_fb_shop_id
,a.yhdj_fb_shop_name
,a.is_super_member
,substring((case when b.birthday is not null then b.birthday else c.birthday end),1,4)
,substring((case when b.birthday is not null then b.birthday else c.birthday end),6,2)
,substring((case when b.birthday is not null then b.birthday else c.birthday end),9,2)

from dm.dm_cqz_member_label as a

left join dwd.dwd_member_center__yh_member_information as b
on a.dim_member_id = b.member_id
and b.birthday is not null and b.birthday <> ''''

left join dwd.dwd_member_center__t_member as c
on a.dim_member_id = c.member_id
and c.birthday is not null and c.birthday <> ''''

where
a.sdt = regexp_replace(date_add(current_date,-1),''-'','''')
and a.yhdj_fb_order_id <> ''''
and case when b.birthday is not null then b.birthday else c.birthday end is not null
and a.yhdj_fb_city_name in (''福州市'',''厦门市'',''上海市'')','会员ID,城市编码,城市名称,仓编码,仓名称,是否超级会员1是,年,月,日','80831324@yonghui.cn,80787185@yonghui.cn','13301996030,18616272395','每周四'),
('福州沉睡流失无效用户','select dim_member_id
,city_name
,type
,dim_shop_id
,is_huawei
,supermember_status
from temp.adl_userlifecycle
where type in (''1'',''2'', ''4'') ---用户类型：1无效 2流失 3新客 4沉睡 5成长 6衰退 8低频
and sdt = regexp_replace(date_add(current_date,-1),''-'','''')
and city_name in ( ''福州市'')
order by city_name,type','用户ID,城市,用户分层名称1无效2流失4沉睡,仓编码,是否华为手机1是0否,是否超级会员1是0否','80831324@yonghui.cn,80731274@yonghui.cn','13301996030,18616272395',' 每周五 15:00左右'),


('福州非沉睡流失无效用户','"Select a.dim_member_id
,a.yhdj_member_life_label_sub
,b.city_name
,b.dim_shop_id
,b.is_huawei
,b.supermember_status
from dm.dm_yh_member_life_cycle as a
left join temp.adl_userlifecycle as b
on a.dim_member_id = b.dim_member_id
where a.yhdj_member_life_label_sub in (''1'', ''2'', ''3'', ''4'', ''5'', ''6'', ''7'', ''8'')
and b.sdt = regexp_replace(date_add(current_date,-1),''-'','''')
and a.sdt = regexp_replace(date_add(current_date,-1),''-'','''')
and b.city_name = ''福州市''
group by a.dim_member_id, a.yhdj_member_life_label_sub,b.city_name,b.dim_shop_id,b.is_huawei,b.supermember_status
order by a.yhdj_member_life_label_sub,b.city_name"','用户ID,用户分层名称
1-忠诚用户
2-低频用户_1 3-低频用户_2
4-培育用户_新用户培育
5-培育用户_预备忠诚_0
6-培育用户_预备忠诚_1
7-培育用户_预备忠诚_2
 8-新客用户,城市,仓编码,是否华为手机 1是 0否,是否超级会员 1是 0否','80831324@yonghui.cn,80731274@yonghui.cn','13301996030,18616272395','每周五 15:00左右'),

('沉睡流失无效用户情况','select a.dim_member_id
,a.city_name
,a.type
,a.dim_shop_id
,a.is_huawei
,b.tag_days_yhdj_lb_now
,count(c.order_id) orderCnt
,sum(c.p_sp_sub_amt) YF
,sum(c.p_paid_sub_amt+c.p_balancepay_sub_amt) SF
from
(select dim_member_id,city_name,type,dim_shop_id,is_huawei
from temp.adl_userlifecycle
where type in (''1'',''2'',''4'') ---用户类型：1无效 2流失 3新客 4沉睡 5成长 6衰退 8低频
and sdt =regexp_replace(date_add(current_date,-1),''-'','''') ---最新数据更新日期
and city_name in ( ''福州市'',''厦门市'')
order by city_name,type) a
join dm.dm_yh_member_label b
on a.dim_member_id= b.dim_member_id
join dm_pw.fct_preposition_order c on a.dim_member_id = c.member_id
where b.sdt= regexp_replace(date_add(current_date,-1),''-'','''')
and length(c.parent_order_id) = 0
and c.refund_flag = ''0''
and c.return_flag = ''0''
and c.sdt between regexp_replace(date_add(current_date,-180),''-'','''')
and regexp_replace(date_add(current_date,-1),''-'','''')
group by a.dim_member_id,a.city_name,a.type,a.dim_shop_id,a.is_huawei,b.tag_days_yhdj_lb_now,a.dim_shop_id','会员ID,城市,用户类型1失效 2流失 4沉睡,仓编码,是否华为手机1是 0否,到家最后一单距今时间,最近180天下单数,最近180天应付金额,最近180天实付金额','80831324@yonghui.cn,cheng@linyunvip.cn','13301996030,18616272395','每周五 15:00左右'),
('到家流量月报','select type_id
,sdate
,edate
,new_add_month_member
,lx_month_member
,new_add_month_member-lx_month_member
,order_month_member
,pay_month_member
,app_month_member
,xcx_month_member
,qc_app_uv
,bqc_app_uv
,qc_xcx_uv
,bqc_xcx_uv
,cast(bqc_uv as double)/cast(qc_uv as double)
,cast(cont_visit_old_member as double)/cast(last_visit_old_member as double)
,cast(cont_visit_new_member as double)/cast(last_visit_new_member as double)
,cast(cont_pay_old_member as double)/cast(last_pay_old_member as double)
,cast(cont_pay_new_member as double)/cast(last_pay_new_member as double)
from dm.dm_yhdj_month_member a
join dim.dim_date b on a.sdate = b.date_id_mom
where type_id in (''福州市'',''厦门市'',''上海市'')
and b.date_code = current_date
and edate = regexp_replace(date_add(current_date,-1),''-'','''') ','城市,新增用户总数,地推拉新数,线上拉新数,月支付用户数 ,总下单用户数,APP下单人数,小程序下单人数,APP UV,APP PV,小程序UV,小程序PV,月均访问频率,老用户月访问留存率,新用户月访问留存率,老用户月下单留存率,新用户月下单留存率','80831324@yonghui.cn,80827438@yonghui.cn,zhengbingxiang@yonghui.cn','13301996030,18616272395','每月1日 14:00左右'),
('到家城市流量周报','select type_id
,sdate
,edate
,new_add_week_member
,lx_week_member
,new_add_week_member-lx_week_member
,order_week_member
,pay_week_member
,app_week_member
,xcx_week_member
,qc_app_uv
,bqc_app_uv
,qc_xcx_uv
,bqc_xcx_uv
,cast(bqc_uv as double)/cast(qc_uv as double)
,cast(cont_visit_old_member as double)/cast(last_visit_old_member as double)
,cast(cont_visit_new_member as double)/cast(last_visit_new_member as double)
,cast(cont_pay_old_member as double)/cast(last_pay_old_member as double)
,cast(cont_pay_new_member as double)/cast(last_pay_new_member as double)
from dm.dm_yhdj_week_member
where type_id in (''福州市'',''厦门市'',''上海市'',''深圳市'')
and sdate = regexp_replace(date_add(current_date,-7),''-'','''')
and edate = regexp_replace(date_add(current_date,-1),''-'','''')','城市,新增用户总数,地推拉新数,线上拉新数,月支付用户数 ,总下单用户数,APP下单人数,小程序下单人数,APP UV,APP PV,小程序UV,小程序PV,月均访问频率,老用户月访问留存率,新用户月访问留存率,老用户月下单留存率,新用户月下单留存率','80831324@yonghui.cn,80827438@yonghui.cn,zhengbingxiang@yonghui.cn','13301996030,18616272395','每周一 14:00左右'),
('到家门店流量周报','select b.city_name
,b.shop_name
,sdate
,edate
,new_add_week_member
,lx_week_member
,new_add_week_member-lx_week_member
,order_week_member
,pay_week_member
,app_week_member
,xcx_week_member
,qc_app_uv
,bqc_app_uv
,qc_xcx_uv
,bqc_xcx_uv
,cast(bqc_uv as double)/cast(qc_uv as double)
,cast(cont_visit_old_member as double)/cast(last_visit_old_member as double)
,cast(cont_visit_new_member as double)/cast(last_visit_new_member as double)
,cast(cont_pay_old_member as double)/cast(last_pay_old_member as double)
,cast(cont_pay_new_member as double)/cast(last_pay_new_member as double)
from dm.dm_yhdj_week_member a
join dim.dim_shop b on a.type_id = b.dim_shop_id
where type_id not in (''福州市'',''厦门市'',''上海市'',''深圳市'')
and sdate = regexp_replace(date_add(current_date,-7),''-'','''')
and edate = regexp_replace(date_add(current_date,-1),''-'','''')','门店ID,新增用户总数,地推拉新数,线上拉新数,月支付用户数 ,总下单用户数,APP下单人数,小程序下单人数,APP UV,APP PV,小程序UV,小程序PV,月均访问频率,老用户月访问留存率,新用户月访问留存率,老用户月下单留存率,新用户月下单留存率','80831324@yonghui.cn,80827438@yonghui.cn,zhengbingxiang@yonghui.cn','13301996030,18616272395','每周一 14:00左右'),
('福州到家上月用户迁移情况','select a.last_flag ,count(distinct if(flag =''1S'',b.member_id,null)) as member_1S ,count(distinct if(flag =''1A'',b.member_id,null)) as member_1A ,count(distinct if(flag =''1B'',b.member_id,null)) as member_1B ,count(distinct if(flag =''1C'',b.member_id,null)) as member_1C ,count(distinct if(flag =''1D'',b.member_id,null)) as member_1D ,count(distinct if(flag =''3S'',b.member_id,null)) as member_3S ,count(distinct if(flag =''3A'',b.member_id,null)) as member_3A ,count(distinct if(flag =''3B'',b.member_id,null)) as member_3B ,count(distinct if(flag =''3C'',b.member_id,null)) as member_3C ,count(distinct if(flag =''3D'',b.member_id,null)) as member_3D ,count(distinct if(flag =''5S'',b.member_id,null)) as member_5S ,count(distinct if(flag =''5A'',b.member_id,null)) as member_5A ,count(distinct if(flag =''5B'',b.member_id,null)) as member_5B ,count(distinct if(flag =''5C'',b.member_id,null)) as member_5C ,count(distinct if(flag =''5D'',b.member_id,null)) as member_5D ,count(distinct if(flag =''7S'',b.member_id,null)) as member_7S ,count(distinct if(flag =''7A'',b.member_id,null)) as member_7A ,count(distinct if(flag =''7B'',b.member_id,null)) as member_7B ,count(distinct if(flag =''7C'',b.member_id,null)) as member_7C ,count(distinct if(flag =''7D'',b.member_id,null)) as member_7D ,count(distinct if(flag =''9S'',b.member_id,null)) as member_9S ,count(distinct if(flag =''9A'',b.member_id,null)) as member_9A ,count(distinct if(flag =''9B'',b.member_id,null)) as member_9B ,count(distinct if(flag =''9C'',b.member_id,null)) as member_9C ,count(distinct if(flag =''9D'',b.member_id,null)) as member_9D ,count(distinct if(flag =''recall'',b.member_id,null)) as member_recall ,count(distinct if(flag =''churn'',b.member_id,null)) as member_churn ,count(distinct if(flag =''new'',b.member_id,null)) as member_new from ( select member_id , flag as last_flag from dm.dm_mkx_rfm_member_statistic_v1 where first_city_id = ''350100'' and first_shop_id <> ''W000'' and sdt = regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') ) as a right join ( select member_id , flag, cnt_1_27 from dm.dm_mkx_rfm_member_statistic_v1 where first_city_id = ''350100'' and first_shop_id <> ''W000'' and sdt = regexp_replace(date_add(last_day(add_months(current_date,-2)),29),''-'','''') ) as b on a.member_id = b.member_id group by a.last_flag order by a.last_flag ','标签,1S,1A,1B,1C,1D,3S,3A,3B,3C,3D,5S,5A,5B,5C,5D,7S,7A,7B,7C,7D,9S,9A,9B,9C,9D,recall,churn,new','80831324@yonghui.cn,80827438@yonghui.cn,zhengbingxiang@yonghui.cn','13301996030,18616272395','每月2号 8:00左右'),
('厦门到家上月用户迁移情况','select a.last_flag

,count(distinct if(flag =''1S'',b.member_id,null)) as member_1S
,count(distinct if(flag =''1A'',b.member_id,null)) as member_1A
,count(distinct if(flag =''1B'',b.member_id,null)) as member_1B
,count(distinct if(flag =''1C'',b.member_id,null)) as member_1C
,count(distinct if(flag =''1D'',b.member_id,null)) as member_1D

,count(distinct if(flag =''3S'',b.member_id,null)) as member_3S
,count(distinct if(flag =''3A'',b.member_id,null)) as member_3A
,count(distinct if(flag =''3B'',b.member_id,null)) as member_3B
,count(distinct if(flag =''3C'',b.member_id,null)) as member_3C
,count(distinct if(flag =''3D'',b.member_id,null)) as member_3D

,count(distinct if(flag =''5S'',b.member_id,null)) as member_5S
,count(distinct if(flag =''5A'',b.member_id,null)) as member_5A
,count(distinct if(flag =''5B'',b.member_id,null)) as member_5B
,count(distinct if(flag =''5C'',b.member_id,null)) as member_5C
,count(distinct if(flag =''5D'',b.member_id,null)) as member_5D

,count(distinct if(flag =''7S'',b.member_id,null)) as member_7S
,count(distinct if(flag =''7A'',b.member_id,null)) as member_7A
,count(distinct if(flag =''7B'',b.member_id,null)) as member_7B
,count(distinct if(flag =''7C'',b.member_id,null)) as member_7C
,count(distinct if(flag =''7D'',b.member_id,null)) as member_7D

,count(distinct if(flag =''9S'',b.member_id,null)) as member_9S
,count(distinct if(flag =''9A'',b.member_id,null)) as member_9A
,count(distinct if(flag =''9B'',b.member_id,null)) as member_9B
,count(distinct if(flag =''9C'',b.member_id,null)) as member_9C
,count(distinct if(flag =''9D'',b.member_id,null)) as member_9D

,count(distinct if(flag =''recall'',b.member_id,null)) as member_recall
,count(distinct if(flag =''churn'',b.member_id,null)) as member_churn
,count(distinct if(flag =''new'',b.member_id,null)) as member_new

from
(
select member_id , flag as last_flag
from dm.dm_mkx_rfm_member_statistic_v1
where first_city_id = ''350200''
and first_shop_id <> ''W000''
and sdt = regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''')
) as a
right join (
select member_id , flag, cnt_1_27
from dm.dm_mkx_rfm_member_statistic_v1
where first_city_id = ''350200''
and first_shop_id <> ''W000''
and sdt = regexp_replace(date_add(last_day(add_months(current_date,-2)),29),''-'','''')
) as b
on a.member_id = b.member_id
group by a.last_flag
order by a.last_flag
','标签,1S,1A,1B,1C,1D,3S,3A,3B,3C,3D,5S,5A,5B,5C,5D,7S,7A,7B,7C,7D,9S,9A,9B,9C,9D,recall,churn,new','80831324@yonghui.cn,80827438@yonghui.cn,chenxiaoxia@yonghui.cn','13301996030,18616272395','每月2号 8:00左右'),
('商品入库查询报表','with result as (select
substring(a.post_date,1,7) as date
,a.company_code -- 公司代码
,a.company_name -- 公司名称
,a.profit_center -- 利润中心
,a.shard_site
,sum(case when a.move_type=''161'' and a.sign_flag=''-'' then a.goods_amt else null end) as thd_amt_1 -- 退货单入库金额
,sum(case when a.move_type=''161'' then a.adjust_amt else null end) as thd_amt_2 -- 本期调整金额
,sum(case when a.move_type=''161'' then a.last_adjust_amt else null end) as thd_amt_3 -- 上期调整金额
,sum(case when a.move_type=''101'' and a.sign_flag=''+'' then a.goods_amt else null end) as ys_amt_1 -- 验收入库金额
,sum(case when a.move_type=''101'' then a.adjust_amt else null end) as ys_amt_2 -- 本期调整金额
,sum(case when a.move_type=''101'' then a.last_adjust_amt else null end) as ys_amt_3 -- 上期调整金额
from
(select b.post_date,a1.id,a1.header_id,a1.article_no,a1.move_type,a1.company_code,a1.company_name,a1.profit_center,a1.shard_site,a1.sign_flag,a1.goods_amt,a1.adjust_amt,a1.last_adjust_amt,a1.site
from dwd.dwd_article_document_center__article_document_item a1
Join dwd.dwd_article_document_center__article_document_header b on a1.header_id = b.id
where
substr(b.post_date,1,7)=substr(date_add(current_date,-10),1,7)
and b.ref_buss_type NOT IN (''receipt_back_samecompany_in'',''receipt_warehouse_samecompany_in'', ''receipt_transfer_samecompany_in_shop'',''receipt_transfer_samecompany_in_warehouse'',
''invoice_samecompany_warehouse_stock_out'', ''invoice_samecompany_transfer_out_shop'',
''invoice_samecompany_transfer_out_warehouse'',''invoice_samecompany_back_stock_out'')
and a1.move_type in (''161'',''101'')
group by b.post_date,a1.id,a1.header_id,a1.article_no,a1.move_type,a1.company_code,a1.company_name,a1.profit_center,a1.shard_site,a1.sign_flag,a1.goods_amt,a1.adjust_amt,a1.last_adjust_amt,a1.site) a
group by substring(a.post_date,1,7),a.company_code ,a.company_name,a.profit_center,a.shard_site)

,result_2 as (select
a.location as location
,sum(a.net_money) as lianying_amt
from dwd.dwd_settlement_supplier_payable_center__supplier_bill_detail a
join dwd.dwd_settlement_supplier_payable_center__supplier_bill b
on a.bill_no =b.bill_no
where a.bill_type in(''ZY75'',''ZY77'',''ZY7A'',''ZY7B'')
and substr(b.account_date,1,7)=substr(date_add(current_date,-10),1,7)
group by location)

select
a.date
,a.company_code
,a.company_name
,a.profit_center
,round((-1)*thd_amt_1+thd_amt_2+thd_amt_3,3) as thd_amt
,round(ys_amt_1+ys_amt_2+ys_amt_3,3) as ys_amt
,round(b.lianying_amt,3) as lianying_amt
from result a
left join result_2 b
on a.shard_site = b.location
where case when thd_amt_1 is null and thd_amt_2 is null and thd_amt_3 is null and ys_amt_1 is null and ys_amt_2 is null and ys_amt_3 is null then 1 else 0 end <> 1
order by a.date,a.company_code,a.company_name,a.profit_center
','日期,公司代码,公司代码名称,门店,退货入库,验收入库,联营入库','2012020023@yonghui.cn,80875195@yonghui.cn','13809882460,18616272395','每月2日16点40分'),
('供应链数字化报表用户使用明细','select
yh_userid
,yh_username
,yh_organization
,yh_userRole
,`$city`
,yh_pagepath
,yh_pagename
,yh_tablename
,yh_appname
,time
from sensors.fct_event_click
where yh_appname=''数据平台 - 辉创 - 云创新零售云平台''
and yh_pagepath in (''供应链数字化-中分类管理-门店-永辉到家中分类在线报表'',''供应链数字化-中分类管理-门店-永辉生活中分类在线报表'',''供应链数字化-中分类管理-门店-超级物种中分类在线报表'',''供应链数字化-中分类管理-永辉到家中分类管理报表'',''供应链数字化-中分类管理-永辉生活中分类管理报表'',''供应链数字化-中分类管理-超级物种中分类管理报表'',''供应链数字化-库存异常-门店-永辉到家库存异常'',''供应链数字化-库存异常-门店-永辉生活库存异常'',''供应链数字化-库存异常-门店-超级物种库存异常'',''供应链数字化-库存异常-城市-永辉到家库存异常'',''供应链数字化-库存异常-城市-永辉生活库存异常'',''供应链数字化-库存异常-城市-超级物种库存异常'',''供应链数字化-损耗折价-门店-永辉到家损耗&折价'',''供应链数字化-损耗折价-门店-永辉生活损耗&折价'',''供应链数字化-损耗折价-门店-超级物种损耗&折价'',
''供应链数字化-损耗折价-城市-永辉到家损耗&折价概况'',''供应链数字化-损耗折价-城市-永辉生活损耗&折价概况'',''供应链数字化-损耗折价-城市-超级物种损耗&折价概况'')
and yh_pagename in (''永辉到家中分类管理'',''永辉生活中分类管理'',''超级物种中分类管理'',''中分类管理报表'',
''门店-永辉到家库存异常'',''门店-永辉生活库存异常'',''门店-超级物种库存异常'',''永辉到家库存异常'',''永辉生活库存异常'',''超级物种库存异常'',''城市-永辉生活损耗&折价'',''城市-超级物种损耗&折价'',''城市-永辉到家损耗&折价'',''门店-永辉生活损耗&折价'',''门店-超级物种损耗&折价'',''门店-永辉到家损耗&折价'')
and time between date_add(current_date,-7) and date_add(current_date,-1)','用户编码,用户名称,用户组织架构,用户角色,城市,报表路径,报表名称,页签,数据平台,日期','leileizhang@yonghui.cn,80679021@yonghui.cn,80743507@yonghui.cn','13261775887,18616272395','每周六'),
('到家拣货员拣货超时奖惩','select
mm
,city_name
, shop_id
, shop_name
, pick_id
, pick_name
,count(order_id) order_cnt
,count(
case when sku_cnt<=8 and pick_duration>72 then order_id
when sku_cnt>8 and pick_duration>(72+(sku_cnt-8)*15) then order_id
else null end
) as cs_cnt
,sum(
case when sku_cnt<=8 and pick_duration>72 then round((pick_duration-72)/60)
when sku_cnt>8 and pick_duration>(72+(sku_cnt-8)*15) then round((pick_duration-(72+(sku_cnt-8)*15))/60)
else 0 end
) as cs_min
from
(select
city_name
, shop_id
, shop_name
, pick_id
, pick_name
, order_id
, regexp_replace(substr(pick_start_at,1,7),''-'','''') mm
, pick_duration*60 as pick_duration
, cast(count(distinct goods_id) as double) as sku_cnt
from dm_pw.dm_delivery_order_time
where regexp_replace(substr(pick_start_at,1,10),''-'','''') between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
and pick_finish_at <> ''''
and pick_finish_at is not null
and parent_order_id = ''''
group by city_name
, shop_id
, shop_name
, pick_id
, pick_name
, order_id
, pick_duration
,regexp_replace(substr(pick_start_at,1,7),''-'','''')
) tt
group by
mm,city_name
, shop_id
, shop_name
, pick_id
, pick_name
order by
mm,city_name
, shop_id
, shop_name
, pick_id
, pick_name','月,城市,仓编码,仓,拣货员id,拣货员名称,订单数,超时订单数(超时规则如绩效方案),超时分钟(按单超时时间四舍五入取整)','80688130@yonghui.cn,80801522@yonghui.cn','18221683607,18616272395','每月5号，下午16:00(资源空闲即可)'),
('到家拣货员退货问题单量','select
regexp_replace(substr(b.review_at,1,7),''-'','''') as mm
,c.city_name
,c.dim_shop_id
,c.shop_name
,pick_id
,pick_name
,count( distinct case when a.reason_type=''return-6'' then d.root_order_id else null end) as bzq

,count( distinct case when a.reason_type=''return-6'' then null
when a.reason_type=''return-2'' then d.root_order_id
else null end) as spzl
,count( distinct case when a.reason_type=''return-6'' then null
when a.reason_type=''return-2'' then null
when a.reason_type=''return-3'' then d.root_order_id
else null end) as spclf
from


dwd.dwd_trade_customer_center__yh_after_sales_order_item a
join dwd.dwd_trade_customer_center__yh_after_sales_order_header b on a.after_sales_order_id=b.id
join dim.dim_shop c on b.shop_id=c.dim_shop_id
join
(
select root_order_id,pick_id,pick_name
from
dm_pw.fct_preposition_order
where order_id=root_order_id
)
d on d.root_order_id=b.root_order_id


where c.city_name in(''福州市'',''上海市'',''厦门市'')
and b.type=''order.return''
and review_status=''reviewed''
and regexp_replace(substr(b.review_at,1,10),''-'','''')
between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
and seller_type_id=''7''
group by
regexp_replace(substr(b.review_at,1,7),''-'','''')
,c.city_name
,c.dim_shop_id
,c.shop_name
,pick_id
,pick_name
order by
c.city_name
,c.dim_shop_id
,c.shop_name
,pick_id
,pick_name','月,城市,仓编码,仓,拣货员id,拣货员名称,保质期问题单量,商品质量问题单量,商品错漏发单量','80688130@yonghui.cn,80801522@yonghui.cn','18221683607,18616272395',' 每月5号，下午16:00'),
('云超mini店拣货员拣货单量','select
substring(datelabel,1,6) as mm
,a.shop_id
,pick.*
,count(distinct a.order_id) as cnt
from
dm_yhsh.dw_deliver_yhsh a
left join
(select order_id,partner_id
from ods.ods_app_t_order_action
where action_type = ''start-pack''
and regexp_replace(substring(action_time,1,10),''-'','''') between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
group by
order_id,partner_id
) b on a.order_id=b.order_id


left join (
select pick.name as pick_name
, u.login_name
, pick.user_id
, pick.staff_code
from ods.ods_app_sys_user_profile as pick
left join ods.ods_app_sys_user as u
on pick.user_id = u.id
) as pick
on pick.user_id = b.partner_id
where datelabel between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
and delivery_order_id=a.order_id
and shop_id in (''9N01'',''9N03'',''9N14'')
group by
substring(datelabel,1,6)
,a.shop_id
,pick. pick_name
,pick.login_name
,pick.user_id
,pick.staff_code','月,门店Id,拣货员姓名,拣货员登录名,拣货员id,拣货员工号,拣货单量','80739502@yonghui.cn,80801522@yonghui.cn','18221683607,18616272395','每月4号，下午16:00'),
('云超百佳店拣货员拣货sku数','select
substring(datelabel,1,6) as mm
,b.carrier_id
,pick.pick_name
,pick.login_name
,pick.staff_code
,sum(cast(a.sku_cnt as decimal))
from
(
select
datelabel,order_id,count(distinct s_sku_code) sku_cnt
from
dm_yhsh.dw_deliver_yhsh_detail
where
datelabel between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
and shop_id=''90C7''
and bom_type<>''2''
group by
datelabel,order_id
) a
join
(
select
order_id,carrier_id
from
dm_yhsh.dw_deliver_yhsh
where
datelabel between regexp_replace(date_add(last_day(add_months(current_date,-2)),1),''-'','''') and regexp_replace(last_day(add_months(current_date,-1)),''-'','''')
and shop_id=''90C7''
and delivery_order_id=order_id
) b on a.order_id=b.order_id
left join
(
select pick.name as pick_name
, u.login_name
, pick.user_id
, pick.staff_code
from ods.ods_app_sys_user_profile as pick
left join ods.ods_app_sys_user as u
on pick.user_id = u.id
) as pick
on pick.user_id = b.carrier_id
group by
substring(datelabel,1,6)
,b.carrier_id
,pick.pick_name
,pick.login_name
,pick.user_id
,pick.staff_code','月,拣货员Id,拣货员姓名,拣货员登录名,拣货员工号,拣货sku数','80739502@yonghui.cn,80801522@yonghui.cn','18221683607,18616272395','每月4号，下午16:00'),
('履单分层围栏数据','with delivery
as
(SELECT
c.city_name
,c.dim_shop_id
,c.shop_name
,a.delivery_order_id
,a.erp_shop_id
,a.receiver_area
,a.member_id
,a.pay_at
,substring(a.delivery_start_at,1,10) delivery_date
,substring(a.delivery_start_at,1,7) date_flag
,a.pick_start_at -- 拣货开始时间
,a.pick_finish_at -- 拣货结束时间
,a.pack_start_time -- 打包开始时间
,a.pack_end_time -- 打包完成时
,a.delivery_start_at -- 配送开始时间
,a.delivery_finish_at -- 配送完成时间
,a.time_slot_date_from
,a.time_slot_date_to -- 预约时间
,round((unix_timestamp(pick_start_at)-unix_timestamp(pay_at))/60,2) wait_time-- 等待时间
,round((unix_timestamp(pick_finish_at)-unix_timestamp(pick_start_at))/60,2) pick_time --拣货时间
,round((unix_timestamp(pack_end_time)-unix_timestamp(pick_finish_at))/60,2) pack_time --打包时间
,round((if(pack_end_time is not null,unix_timestamp(pack_end_time),unix_timestamp(pick_finish_at))-unix_timestamp(pay_at))/60,2) cang_time --仓内时间
,round((unix_timestamp(delivery_start_at)-if(pack_end_time is not null,unix_timestamp(pack_end_time),unix_timestamp(pick_finish_at)))/60,2) taimian_time-- 台面时间
,round((unix_timestamp(delivery_finish_at)-unix_timestamp(delivery_start_at))/60,2) delivery_time-- 配送时间
,round((unix_timestamp(delivery_finish_at)-if(pack_end_time is not null,unix_timestamp(pack_end_time),unix_timestamp(pick_finish_at)))/60,2) peisong_time-- 配送端时间
,round((unix_timestamp(delivery_finish_at)-unix_timestamp(pay_at))/60,2) lvyue_time-- 履约时间
,round((unix_timestamp(delivery_finish_at)-unix_timestamp(concat(time_slot_date_to,'':00'')))/60,2) cs_time-- 超时时间
,round((unix_timestamp(concat(time_slot_date_to,'':00''))-unix_timestamp(concat(time_slot_date_from,'':00'')))/60,0)
yy_time
,case when a.time_slot_type=''expectTime'' then ''预约单''
else ''极速达'' end time_slot_type
,if(substring(delivery_finish_at,1,16)<=substring(time_slot_date_to,1,16),1,0) is_wmly

from dm_pw.fct_preposition_order a
join dim.dim_shop c on a.erp_shop_id=c.dim_shop_id and c.city_name in (''福州市'',''厦门市'',''上海市'')
left join (
select id
from dim.dim_sys_user_role_profile
where role_code in (''yonghuiguanjia-shop-manager'' , ''yonghuiguanjia-shop-manager-type-2'')
group by id
) as u on u.id=a.partner_id
where
substring(a.delivery_start_at,1,10)= date_add(current_date,-1)
and a.order_type=''配送''
and a.earth_flag=''0''
and a.delivery_order_id=a.order_id
and a.delivery_start_at<>''''
and a.delivery_finish_at<>''''
and a.partner_id<>''''
and a.delivery_start_at is NOT NULL
and a.delivery_finish_at IS NOT NULL
and a.partner_id is not null
and u.id is null

)

select
a.*
,a.yy_order_cnt/b.order_cnt as ddzb
from
(
select
city_name
,dim_shop_id
,shop_name
,delivery_date
,yy_time
,count(distinct delivery_order_id) yy_order_cnt
,count(distinct if(is_wmly=1,delivery_order_id,null))/count(distinct delivery_order_id) as wmly_order_rate
,if(yy_time=30,count(distinct if(is_wmly=1,delivery_order_id,null))/count(distinct delivery_order_id),
count(distinct if(lvyue_time<31,delivery_order_id,null))/count(distinct delivery_order_id)) min30_order_rate

,count(distinct if(cs_time>30,delivery_order_id,null))/count(distinct delivery_order_id) as yz_ch_rate
,count(distinct case when yy_time=30 and cang_time>5 then delivery_order_id
when yy_time=45 and cang_time>10 then delivery_order_id
when yy_time=60 and cang_time>15 then delivery_order_id
else null end
)
/count(distinct delivery_order_id) as cn_js_rate
,count(distinct case when yy_time=30 and peisong_time>25 then delivery_order_id
when yy_time=45 and peisong_time>35 then delivery_order_id
when yy_time=60 and peisong_time>45 then delivery_order_id
else null end
)
/count(distinct delivery_order_id) as ps_js_rate

,sum(if(time_slot_type=''极速达'',wait_time,0))
/count(distinct if(time_slot_type=''极速达'',delivery_order_id,null)) as dd --等待时效

,sum(pick_time)/count(distinct delivery_order_id) as jh--拣货时效

,sum(pack_time)/count(distinct delivery_order_id) as db --打包时效

,sum(if(time_slot_type=''极速达'',taimian_time,0))
/count(distinct if( time_slot_type=''极速达'',delivery_order_id,null)) as tm --台面时效




,sum(delivery_time)/count(distinct delivery_order_id) as ps --配送时效



,count(distinct if(cang_time<=5 ,delivery_order_id,null))/count(distinct delivery_order_id) as min5_c

from delivery
where time_slot_type=''极速达''
group by
city_name
,dim_shop_id
,shop_name
,delivery_date
,yy_time
) a
left join
(
select
dim_shop_id
,delivery_date
,count(distinct delivery_order_id) order_cnt
from delivery
where time_slot_type=''极速达''
group by
dim_shop_id
,delivery_date
) b
on a.dim_shop_id=b.dim_shop_id and a.delivery_date=b.delivery_date
order by
city_name
,dim_shop_id
,shop_name
,delivery_date
,yy_time','城市,仓id,仓,配送开始日期,极速达时长,单量,及时履约率,30分钟送达率,严重履超时率,仓内超时率,配送超时率,等待时长,拣货时长,打包时长,台面时长,配送时长,仓内5min履约率,单量占比(分母为极速达订单)','2002040015@yonghui.cn,80801522@yonghui.cn,80297360@yonghui.cn,80839020@yonghui.cn,xizhuqing@yonghui.cn','18221683607,18616272395','每天，中午13：00'),
('福州厦门订单明细','select
a.pay_at
,a.root_order_id
,a.member_id
,b.city_name
,a.erp_shop_id
,b.shop_name
,round(a.p_sp_sub_amt,3) as p_sp_sub_amt
,round(a.p_promo_sub_amt,3) as p_promo_sub_amt
,round(a.p_balancepay_sub_amt,3) as p_balancepay_sub_amt
,round(a.p_pointpay_sub_amt,3) as p_pointpay_sub_amt
,round(a.p_paid_sub_amt,3) as p_paid_sub_amt
,a.channel_name
, date_add(current_date,-7)
, date_add(current_date,-1)
from dm_pw.fct_preposition_order as a
join dim.dim_shop as b on a.erp_shop_id=b.dim_shop_id
where a.sdt between between date_add(current_date,-7) and date_add(current_date,-1) -- ---- 每周一到周天
and dim_date_id between date_add(current_date,-7) and date_add(current_date,-1) -- ---- 每周一到周天
and parent_order_id=''''
and b.city_code in (''350100'',''350200'')
and earth_flag<>''1''
and rje_flag=''0''
order by a.pay_at,b.city_name,a.erp_shop_id,b.shop_name,a.member_id','支付时间,订单号,会员ID,城市名称,门店ID,门店名称,应付金额,促销金额,余额支付,积分支付,实付金额,渠道,开始日期,结束日期','2009040221@yonghui.cn,xiaoyegao@yonghui.cn','13661843893,18616272395','每周一，下午13：00'),
('福州TOP商品','select
aa.dim_shop_id
,aa.shop_name
,max(case when rank_order_num=1 then aa.dim_goods_id else null end) as rank_order_numrank1_goodsid -- 订单量第一
,max(case when rank_order_num=1 then aa.goods_name else null end) as rank_order_numrank1_goods_name

,max(case when rank_order_num=2 then aa.dim_goods_id else null end) as rank_order_numrank2_goodsid -- 订单量第二
,max(case when rank_order_num=2 then aa.goods_name else null end) as rank_order_numrank2_goods_name

,max(case when rank_order_num=3 then aa.dim_goods_id else null end) as rank_order_numrank3_goodsid -- 订单量第三
,max(case when rank_order_num=3 then aa.goods_name else null end) as rank_order_numrank3_goods_name

,max(case when rank_sale_amt=1 then aa.dim_goods_id else null end) as rank_sale_amtrank1_goodsid -- 销售额第一
,max(case when rank_sale_amt=1 then aa.goods_name else null end) as rank_sale_amtrank1_goodsname

,max(case when rank_sale_amt=2 then aa.dim_goods_id else null end) as rank_sale_amtrank2_goodsid -- 销售额第一
,max(case when rank_sale_amt=2 then aa.goods_name else null end) as rank_sale_amtrank2_goodsname

,max(case when rank_sale_amt=3 then aa.dim_goods_id else null end) as rank_sale_amtrank3_goodsid -- 销售额第一
,max(case when rank_sale_amt=3 then aa.goods_name else null end) as rank_sale_amtrank3_goodsname
, date_add(current_date,-7)
, date_add(current_date,-1)
from
(
select
a.dim_shop_id
,a.shop_name
,a.dim_goods_id
,a.goods_name
,a.order_num
,a.sale_amt
,row_number() over(partition by a.dim_shop_id order by order_num) as rank_order_num
,row_number() over(partition by a.dim_shop_id order by sale_amt) as rank_sale_amt
from
(select
a.dim_shop_id
,b.shop_name
,a.dim_goods_id
,c.goods_name
,count(distinct a.order_id) as order_num
,round(sum(a.p_sp_sub_amt),2) as sale_amt -- 销售额
from dm_pw.fct_preposition_order_item a
join dim.dim_shop b on a.dim_shop_id = b.dim_shop_id
join dim.dim_goods c on a.dim_goods_id= c.dim_goods_id
where a.sdt between between date_add(current_date,-7) and date_add(current_date,-1)
and b.city_code = ''350100'' -- 福州
group by a.dim_shop_id,b.shop_name,a.dim_goods_id, c.goods_name
order by a.dim_shop_id) as a

) as aa -- 销量排名

group by aa.dim_shop_id
,aa.shop_name','门店编码,门店名称,本周订单量第1单品编码,本周订单量第1单品名称,本周订单量第2单品编码,本周订单量第2单品名称,本周订单量第3单品编码,本周订单量第3单品名称,本周销售额第1单品编码,本周销售额第1单品名称,本周销售额第2单品编码,本周销售额第2单品名称,本周销售额第3单品编码,本周销售额第3单品名称,开始日期,结束日期','2009040221@yonghui.cn,xiaoyegao@yonghui.cn','13661843893,18616272395','每周一，下午13：00')
