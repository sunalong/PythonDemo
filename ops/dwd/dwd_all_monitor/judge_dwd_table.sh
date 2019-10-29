#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo curr_dir:$curr_dir

dwd_list_file=${curr_dir}/dwd_list.txt


PYTHONPATH=$(cd `dirname $0`/../../../../../; pwd)
echo PYTHONPATH:${PYTHONPATH}
export PYTHONPATH=${PYTHONPATH}
source /data/soft/py3__env/bin/activate
#source ~/.py3_env/bin/activate


#获取mysql表中的表列表
#mysql -h10.10.49.190 -udev_user -pYgvb456# -Ddata_governance -se "select * from data_governance.dim_dwd_table_info" >${curr_dir}/table.txt

# 使用while读取不到最后一行(当最后一行没有回车换行符时)
#while read line;do
#    hive_table_name=$line
#    echo hive_table_name:${hive_table_name}
##    python ${curr_dir}/../MonitorDwd.py  judge ${hive_table_name}
#done<${dwd_list_file}

# for对文件的读是按字符串的方式进行的，遇到空格什么后，再读取的数据就会换行显示; while相对for的读取很好的还原数据原始性
#for line in `cat ${dwd_list_file}`;do
#    ecoh line:$line
#    line_arr=(${line//#/ })
#    last_crontab_time=${line_arr[0]}" "${line_arr[1]}
#    hive_table_name=${line_arr[2]}
#    echo hive_table_name:${hive_table_name}
#    python ${curr_dir}/../MonitorDwd.py  judge ${hive_table_name}
#done
while read line;do
    echo line:$line
    line_arr=(${line//#/ })
    last_crontab_time=${line_arr[0]}" "${line_arr[1]}
    hive_table_name=${line_arr[2]}
    echo hive_table_name:${hive_table_name}
    python ${curr_dir}/../MonitorDwd.py  judge ${hive_table_name}
done<${dwd_list_file}

deactivate
