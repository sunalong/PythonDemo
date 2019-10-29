#! /bin/bash -x


declare -r curr_dir=$(cd `dirname $0`; pwd)
shop_data_dir=${curr_dir}/dbbos_shops
host_dir="/data/soft/get_rongtong_host/host_shop.txt"

echo "$1"
if [ -z $1 ] ; then
 curr_day=`date -d " -1 day " +%Y%m%d`
else
 curr_day=`date -d "$1" +%Y%m%d`
fi

# 1.执行 hive 语句查询遗漏数据的融通门店
hive -e "
INSERT OVERWRITE LOCAL DIRECTORY '${shop_data_dir}' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
SELECT a.dim_shop_id
from dim.dim_shop as a
left join (
  select shopid
  from dwd.dwd_dbbos__dayshopstock_sh
  where sdt='${curr_day}'
  group by shopid
) as b
on a.dim_shop_id = b.shopid
where a.status='1'
and a.is_hc_enabled='0'
and regexp_replace(substr(actual_open_date,1,10),'-','')<='${curr_day}'
and a.seller_type_id in ('0','2','7')
and b.shopid is null
and a.dim_shop_id not in ('9I27')
"

ret=$?
if [ '$ret' -nq "0" ];then
    echo "Error 获取融通门店所有门店号失败"
else
    cat ${shop_data_dir}/0* >${shop_data_dir}/shop_list.txt
fi

awk 'BEGIN{ ORS=" " } {print $1}'  ${shop_data_dir}/shop_list.txt > ${shop_data_dir}/empty_shop.txt

# 4.将 ${shop_data_dir}/empty_shop.txt 中的内容报警出去
empty_shop=`cat ${shop_data_dir}/empty_shop.txt`
if [ "${empty_shop}" == "" ];then
    echo "所有门店都被抽取了"
    exit 0
fi
report_msg="---- 融通门店数据 ----
表:dwd.dwd_dbbos__dayshopstock_sh
抽取日期:${curr_day}
没有抽到数据的门店：
 ${empty_shop}"

echo "report_msg: ${report_msg}"

${curr_dir}/../../utils/exceptionAlert.sh --msg "${report_msg}" --group "大数据作业异常预警"


#print("reportmsg fuck:",report_msg,":strip len:",len(str.strip(''.join(error_list))))
#WechartRobot().alert(group=WechartRobot.task_exception_group, msg=report_msg)

#解决方法：
#sqoop@uhadoop-mzwc2w-task1:/data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh$ pwd
#/data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh
#sqoop@uhadoop-mzwc2w-task1:/data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh$ cp ../host_shop.txt ../host_shop.txt_bak
#sqoop@uhadoop-mzwc2w-task1:/data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh$ vim ../host_shop.txt
#sqoop@uhadoop-mzwc2w-task1:/data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh$ ./crontab_dbbos__dayshopstock_sh.sh