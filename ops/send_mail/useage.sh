#!/bin/bash
"""
数据自动化导出工具,如果需要更新内容,可以自已动手
"""
mysql信息:
    host='10.10.49.190',
    port=3306,
    user='dev_user',
    passwd='Ygvb456#',
    db='data_governance',

DDL
    create table data_governance.auto_send_email (
      subject varchar(100) comment '邮件名称，同生成的文件名称'
    , sql_str text comment '取数sql'
    , fields_comment text comment '输出字段的中文名称，以逗号分隔'
    , receiver text comment '收件人邮箱地址，以逗号分隔'
    , producter varchar(100) comment '失败后发送群通知的产品人员的手机号'
    , crontab text comment '调度周期'
    , status  int(1) NOT NULL DEFAULT 0 COMMENT '任务状态，0 数据插入默认为0，1 已经配置成功，2 更新'
    , insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据插入时间'
    , PRIMARY KEY (subject)
    )comment '执行sql,将结果 自动发送csv压缩文件给指定邮箱'
    ;
使用说明：
    每天17点会自动扫描此表,根据 status 的状态来处理：
        如果 status=0:状态为新插入，机器人会在群里 @孙阿龙 通知其来添加调度
        如果 status=2:状态为更新，程序会自动更新新更新的 sql代码、配置信息


使用方法：
总共有两种，一是新插入一条记录，二是更新原有的记录；
一：新插入记录：
    代码示例：
        INSERT into data_governance.auto_send_email (subject,sql_str,fields_comment,receiver,producter,crontab)
        VALUES
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
        order by a.pay_at,b.city_name,a.erp_shop_id,b.shop_name,a.member_id','支付时间,订单号,会员ID,城市名称,门店ID,门店名称,应付金额,促销金额,余额支付,积分支付,实付金额,渠道,开始日期,结束日期','2009040221@yonghui.cn,xiaoyegao@yonghui.cn','13661843893,18616272395','每周一，下午13：00')

    需要注意的是：sql_str中的代码，在hue中若为单引号，这里需要变为两个单引号


二：更新记录：
    update data_governance.auto_send_email set status=2,fields_comment='支付时间,订单号' where subject='福州厦门订单明细'
    注意点：插入时 status 默认为0，不用处理；但更新时需要手动将其设置为2


验证是插入或更新是否成功:
    select *
    from data_governance.auto_send_email

然后看查询出来的值是否是自已要设置的值


周期性需求工具 wiki 文档地址：
http://wiki.yonghuivip.com/pages/viewpage.action?pageId=7302964

