
#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)

# 执行插入文件，将数据插入到tmp 表中
mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance -se "truncate data_governance.tmp_yarn_application_info"
cat ${curr_dir}/seg_file_to_insert/seg_file_to_insert_* | mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance

ret=$?
echo "执行插入文件，将数据插入到tmp 表中 ret:${ret}"




if [ "$ret" -ne "0" ] ; then
    echo "ERROR30  insert into data_governance.ods_yarn_application_info error"
    exit 30;
else
    rm ${curr_dir}/seg_file_to_insert/*
    # 去重到dwd 表
    mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance -se "
        replace into data_governance.dwd_yarn_application_info
        select app_id, app_name, app_type, user, queue, start_time, finish_time, mem_value, vcore_value, mem_unit, vcore_unit, progress, state, final_state, tracking_url, rpc_port, am_host, insert_time
        from (select * ,row_number() over(partition by app_id order by finish_time desc)as num
              from (select app_id, app_name, app_type, user, queue, start_time, finish_time, mem_value, vcore_value, mem_unit, vcore_unit, progress, state, final_state, tracking_url, rpc_port, am_host, insert_time
                    from data_governance.tmp_yarn_application_info
                    union
                    select app_id, app_name, app_type, user, queue, start_time, finish_time, mem_value, vcore_value, mem_unit, vcore_unit, progress, state, final_state, tracking_url, rpc_port, am_host, insert_time
                    from data_governance.ods_yarn_application_info
                    ) as all_data
              )as all_data
        where all_data.num=1
    "
fi



ret=$?
echo "去重到dwd 表 ret:${ret}"

if [ "$ret" -ne "0" ] ; then
    echo "ERROR30  去重到 data_governance.dwd_yarn_application_info 表 error"
    exit 30;
else
    # dwd数据回写到ods表 overwrite
    mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance -se "
        replace into data_governance.ods_yarn_application_info
        select app_id, app_name, app_type, user, queue, start_time, finish_time, mem_value, vcore_value, mem_unit, vcore_unit, progress, state, final_state, tracking_url, rpc_port, am_host, insert_time
        from data_governance.dwd_yarn_application_info
    "
fi


ret=$?
echo "dwd数据回写到ods表 ret:${ret}"

if [ "$ret" -ne "0" ] ; then
    echo "ERROR30  dwd数据回写到ods表 data_governance.ods_yarn_application_info 表 error"
    exit ${ret}
fi

