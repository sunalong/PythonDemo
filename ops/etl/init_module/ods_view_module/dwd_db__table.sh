#! /bin/bash -x

# 作者： 孙阿龙
# 声明不可变变量 并为其复制为当前路径
declare -r curr_dir=$(cd `dirname $0`; pwd)
curr_date=`date +%Y%m%d`
curr_time=`date +%H%M%S`

file_name="dwd_db__table"
file_sql=${curr_dir}/${file_name}".sql"


#check_table -m check -f ${curr_dir}/dependencies

check_table -m insert -d dwd -t __dwd_db__table__

if [ "$1" = "foreach" ]; then
  start_date="$2"
  end_date="$3"
else
  #start_date=`date -d "yesterday" +%Y-%m-%d`
  start_date=`date +%Y-%m-%d -d " -3 day"`
  end_date=`date +%Y-%m-%d`
fi
echo "执行日期为==""${curr_date} ${curr_time}"

# hive计算
hive --hivevar start_date="${start_date}" -f  ${file_sql}


ret=$?
if [ "${ret}" -eq "0" ]; then
  check_table -m update -d dwd -t __dwd_db__table__ -s 2
else
  check_table -m update -d dwd -t __dwd_db__table__ -s 1
fi

MonitorDwd i __dwd_db__table__
MonitorDwd j __dwd_db__table__

