#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo "$1"
if [ -z $1 ] ; then
 today=`date -d " -0 day " +%Y-%m-%d`
else
 today=`date -d "$1" +%Y-%m-%d`
fi

today_0=`date -d "${today} -0 day" +%Y%m%d`
today_1=`date -d "${today} -1 day" +%Y%m%d`
today_2=`date -d "${today} -2 day" +%Y%m%d`

# 一：生成 要view 数据文件的目录 到txt文件中
hdfs dfs -ls /user/sqoop/ods/ods_flume_json_* | awk -F ' ' '{print $8}' | awk -F 'datelabel' '{print $1}'|uniq |sed '/^$/d'  >${curr_dir}/view_dir.txt


# 二：拼接每个目录的最近三天的日期
#hdfs fsck /user/sqoop/ods/ods_flume_json_trade_order_pay  -openforwrite | grep OPENFORWRITE | sed -r 's/\.{2,1000}/\n/g' |sed 's/^[ \.]*//g'| awk -F ':| ' '$1!="" {if($0!~"json.tmp") print $1}'
suffix="-openforwrite | grep OPENFORWRITE | sed -r 's/\.{2,1000}/\n/g' |sed 's/^[ \.]*//g'| awk -F ':| ' '\$1!=\"\" {if(\$0!~\"json.tmp\") print \$1}'"
echo suffix:${suffix}
rm ${curr_dir}/dir_to_check.txt
while read line;do
    echo "hdfs fsck ${line}datelabel=${today_0} ${suffix}">>${curr_dir}/dir_to_check.txt
    echo "hdfs fsck ${line}datelabel=${today_1} ${suffix}">>${curr_dir}/dir_to_check.txt
    echo "hdfs fsck ${line}datelabel=${today_2} ${suffix}">>${curr_dir}/dir_to_check.txt
        #dir_to_be_clear=`echo $line | awk 'BEGIN{OFS="-";FS=" "} {print $5}' `      # 提取文件中的目录
done < ${curr_dir}/view_dir.txt      # 读取存储要清除数据的目录文件


# 三：检查目录，将需要恢复租约状态的文件放到 文件中
bash ${curr_dir}/dir_to_check.txt &> ${curr_dir}/open_for_write_json.txt

# 删除  Connecting to namenode via http://uhadoop-mzwc2w-master1:50070
sed -i /^Connecting/d ${curr_dir}/open_for_write_json.txt


# 四：读取要恢复租约状态的文件并恢复
#hdfs debug recoverLease -path /user/sqoop/ods/ods_flume_json_trade_order_pay/datelabel=20180806/trade_order_pay.1533510934773.json
echo `date` >>${curr_dir}/final_recover_log.txt
echo `date` >>${curr_dir}/final_recover_log_aaa.txt
while read line;do
    echo "hdfs debug recoverLease -path  ${line}">>${curr_dir}/final_recover_log.txt
    hdfs debug recoverLease -path  ${line}>>${curr_dir}/final_recover_log_aaa.txt
done <  ${curr_dir}/open_for_write_json.txt      # 读取存储要清除数据的目录文件

