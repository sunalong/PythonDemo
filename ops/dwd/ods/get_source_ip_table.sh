#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
ods_ip_table_all="${curr_dir}/data/ods_ip_table_all"
ods_ip_table_no_colon="${curr_dir}/data/ods_ip_table_no_colon"
ods_ip_table_no_symbol="${curr_dir}/data/ods_ip_table_no_symbol"

# 获取ip\port 及 table 所在的行
grep  'ip_addr="[0-9A-Za-z]\|port="[0-9]\|query_state="[A-Za-z ,_]* from' -r /data/app/dev/data_biz/etl/  &>${ods_ip_table_all}



#清洗数据：只取ip、port的值及源表：db.table

#去含有#的行
sed -i /#/d ${ods_ip_table_all}

#去除 = 和 " 符号  结果如：10.9.172.50 select id,...,last_updated_at from delivery_station_db.t_community where  last_updated_at >
awk -F '=|"' '{print $1,$3}' ${ods_ip_table_all} &> ${ods_ip_table_no_symbol}

# 将 select ... from db.table where 中的 db.table 过滤出来
#不能直接grep,否则不能与ip一一对应，可使用替换，将 db.table 前后替换为空即可
#删除 from 及之前的字符
sed -i 's/select[A-Za-z, _]*from //' ${ods_ip_table_no_symbol}
#删除 where 及之后的字符
sed -i 's/ where[A-Za-z, _>]*//' ${ods_ip_table_no_symbol}

#去除 ip_addr port query_state
sed -i 's/ip_addr //' ${ods_ip_table_no_symbol}
sed -i 's/port //' ${ods_ip_table_no_symbol}
sed -i 's/query_state //' ${ods_ip_table_no_symbol}

#去除/data/app/dev/data_biz/etl
sed -i 's#/data/app/dev/data_biz/etl#.#' ${ods_ip_table_no_symbol}

#./mms_finance_center/fc_tax_classification/mysql2HiveTmp.sh:10.9.28.119
#./mms_finance_center/fc_tax_classification/mysql2HiveTmp.sh:3306
#./mms_finance_center/fc_tax_classification/mysql2HiveTmp.sh:mms_finance_center.fc_tax_classification


#查看comment
presto-client-task13 --execute 'desc dwd.dwd_dbbos__changeunitgoods'
presto-client-task13 --execute 'desc dwd.dwd_dbbos__goods'


comment_str=`cat test  |awk -F ',' '{print $4}'|sort |sed -n '1p'`
echo comment_str:${comment_str}
if [ ${comment_str}=='""' ];then
    echo comment_str has empty comment
else
    echo comment_str donnot have empty comment
fi


##清洗数据：只取ip、port的值及源表：db.table
#
##去除冒号前面的文件名
#awk -F ":" '{print $2}' ${ods_ip_table_all} >${ods_ip_table_no_colon}
#
##去除#开头的行
#sed -i /^#/d ${ods_ip_table_no_colon}
#
##去除 = 和 " 符号  结果如：10.9.172.50 select id,...,last_updated_at from delivery_station_db.t_community where  last_updated_at >
#awk -F '=|"' '{print $3}' ${ods_ip_table_no_colon} &> ${ods_ip_table_no_symbol}
#
## 将 select ... from db.table where 中的 db.table 过滤出来
##不能直接grep,否则不能与ip一一对应，可使用替换，将 db.table 前后替换为空即可
##删除 from 及之前的字符
#sed -i 's/[A-Za-z, _]*from //' ${ods_ip_table_no_symbol}
##删除 where 及之后的字符
#sed -i 's/ where[A-Za-z, _>]*//' ${ods_ip_table_no_symbol}



