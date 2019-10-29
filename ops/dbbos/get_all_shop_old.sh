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

# 1.执行 hive 语句查询有数据的融通门店
hive -e "
INSERT OVERWRITE LOCAL DIRECTORY '${shop_data_dir}' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
SELECT a.shopid,b.dim_shop_id
FROM dwd.dwd_dbbos__dayshopstock_sh as a
inner join (
select dim_shop_id
from dim.dim_shop
where status='1'
and is_hc_enabled='0'
)as b on a.shopid = b.dim_shop_id
where a.sdt='${curr_day}'
group by a.shopid,b.dim_shop_id
"

ret=$?
if [ '$ret' -nq "0" ];then
    echo "Error 获取融通门店所有门店号失败"
else
    cat ${shop_data_dir}/0* >${shop_data_dir}/shop_list.txt
fi


# 2.将 79 上的 host_shop.txt 文件拷贝到当前目录
scp  sqoop@10-10-64-79:${host_dir} ${shop_data_dir}/

# 3.比较 shop_list.txt 和 host_shop.txt 去重, 剩余的即为没有抽到的门店
awk -F ' ' '{print $2}' ${shop_data_dir}/host_shop.txt>${shop_data_dir}/all_host.txt
awk '{print NR, $0}' ${shop_data_dir}/all_host.txt  ${shop_data_dir}/shop_list.txt |sort -k2|uniq -u -f 1|sort -k1|awk 'BEGIN{ ORS=" " } {print $2}' > ${shop_data_dir}/empty_shop.txt

# 4.将 ${shop_data_dir}/empty_shop.txt 中的内容报警出去

report_msg="融通门店：
表：ods_tmp.dbbos__dayshopstock_sh
抽取日期:${curr_day}
没有抽到数据的门店：
 `cat ${shop_data_dir}/empty_shop.txt`"

echo "report_msg: ${report_msg}"

../../utils/exceptionAlert.sh --msg "${report_msg}" --group "大数据重点项目预警"


#print("reportmsg fuck:",report_msg,":strip len:",len(str.strip(''.join(error_list))))
#WechartRobot().alert(group=WechartRobot.task_exception_group, msg=report_msg)
