#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)

db=$1
table=$2
interval=$3

if [ $# -lt 2 ]; then
echo "useage: sh ./create.sh db  table interval"
exit 1
fi
currentDate=`date +%Y-%m-%d`
currentTime=`date +%H%M%S`

curr_time="${currentDate}_${currentTime}"
cd ${curr_dir}
prefix="ods_flume_json"

module_db="module_db_name"
module_table="module_table_name"
module_db_table="${prefix}_${module_db}__${module_table}"

dest_db_table="${prefix}_${db}__${table}"

if [ -d "$dest_db_table" ]; then 
   mv ${dest_db_table} ${dest_db_table}_${curr_time}
fi

if [ -z "${interval}"  ]; then
interval=600
fi 


cp -rf ${module_db_table} ${dest_db_table}


cd $curr_dir/${dest_db_table}
mv ${module_db_table}.sh ${dest_db_table}.sh
mv crontab_${module_db_table}.sh crontab_${dest_db_table}.sh
mv ${module_db_table}.properties ${dest_db_table}.properties
mv ${module_db_table}.sql ${dest_db_table}.sql


#sed -i "s/${module}/${dest_db_table}/g" ./*
sed -i "s/${module_table}/${table}/g" ./*
sed -i "s/${module_db}/${db}/g" ./* 
sed -i  "s/rollInterval = 600/rollInterval = ${interval}/g" ${dest_db_table}.properties

hive -f ${dest_db_table}.sql

cd $curr_dir

#执行创建ods_view表
hive -f $curr_dir/${table}_view/view_ods_flume_json_db__table.sql

