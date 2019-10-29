#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo curr_dir:$curr_dir

dwd_list_file=${curr_dir}/dwd_list.txt
insert_state_file=${curr_dir}/insert_dim_dwd_table_info.sql


#   一：获取dwd层目录下的所有dwd表的表名
#以多个空格和斜杠为分隔符，结果以#分隔以便下一步的切分
hdfs dfs -ls /user/hive/warehouse/dwd.db/ |awk -F "[' ','/']+" '{print $6,$7"#"$12}' >${dwd_list_file}
#删除首行(# 独占一行）
sed -i '/^[ #]*$/d' ${dwd_list_file}

#   二：遍历dwd_list,拼接插入语句
echo -e "INSERT INTO data_governance.dim_dwd_table_info (hive_table_name,max_field,last_crontab_time,partition_field) VALUES \n" >${insert_state_file}
while read line;do
    # 使用空格来替换井号 # ${parameter//pattern/string} 用string来替换parameter变量中所有匹配的pattern
    line_arr=(${line//#/ })
    last_crontab_time=${line_arr[0]}" "${line_arr[1]}
    hive_table_name=${line_arr[2]}
    # 获取 last_updated_at 或 last_updated_by 字段
    max_field=`presto-client-task27 --execute "desc dwd.${hive_table_name}" | grep last_update|awk -F '"|,' '{print $2}'`

    # 获取分区字段
    partition_field=`presto-client-task27 --execute "desc dwd.${hive_table_name}" | grep 'partition key'|awk -F '"|,' '{print $2}'`

    echo "('${hive_table_name}','${max_field}','${last_crontab_time}','${partition_field}'), ">>${insert_state_file}
done<${dwd_list_file}


#   三：最后一行的逗号改为分号
sed -i '$s#\(.*\),#\1;#' ${insert_state_file}



#   四：执行插入文件，将数据插入到tmp 表中
mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance -se "truncate data_governance.dim_dwd_table_info"
cat ${insert_state_file} | mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance
ret=$?
echo "执行插入文件，将数据插入到tmp 表中 ret:${ret}"
if [ "$ret" -ne "0" ] ; then
    echo "ERROR30  insert into data_governance.dim_dwd_table_info error"
    exit 30;
fi


