#! /bin/bash +x
#
# 作者： 孙阿龙
# 配置增量调度脚本
#


declare -r curr_dir=$(cd `dirname $0`; pwd)

currentDate=`date +%Y-%m-%d`
currentTime=`date +%H%M%S`

mysql_host="$1"
mysql_port="$2"
mysql_db_name="$3"
mysql_table_name="$4"
primary_key="$5"
order_field="$6"
mr_count="$7"
ods_view_hive_table_name="view_ods_flume_json_${mysql_db_name}__${mysql_table_name}"
ods_hive_table_name="ods_${mysql_db_name}__${mysql_table_name}"
dwd_hive_table_name="dwd_${mysql_db_name}__${mysql_table_name}"
split_id=`echo "$primary_key" | awk  -F "," '{print $1}'`
tardir="${mysql_table_name}_view"

echo "mysql_host=$mysql_host"
echo "mysql_port=$mysql_port"
echo "mysql_db_name=$mysql_db_name"
echo "mysql_table_name=$mysql_table_name"
echo "primary_key=$primary_key"
echo "order_field=$order_field"
echo "ods_hive_table_name=$ods_hive_table_name"
echo "ods_view_hive_table_name=$ods_view_hive_table_name"
echo "split_id=$split_id"



if [ "$#" -lt "7" ]; then

 echo "Error19: expect 7 param"
 echo "useage: /bin/bash xxxx.sh mysql_table_name ods_hive_table_name  split_id primary_key"
 exit 19;
fi


echo "----------------------准备模板和元数据------------------------------"
hive_sql="use ods; desc ${ods_hive_table_name}"
deal_sql="awk '{print $1","}'  |  tr -d ["\n"]  | sed  's/,$//'"
columns=`hive -e "${hive_sql}" |awk '{print $1","}'  |  tr -d ["\n"]  | sed  's/,$//'`
#sql="""hive -e "use ods; desc ${ods_hive_table_name}" | awk '{print $1","}'  |  tr -d ["\n"]  | sed  's/,$//'"""
echo "columns:"${columns}
if  [ "$?" -ne "0" ]; then
   echo "Error21: get columns error"
   exit 21;
fi

echo "columns=$columns"
if [ -d "${tardir}" ] ;then
    mv  ${curr_dir}/${tardir} ${curr_dir}/${tardir}_bak_${currentDate}-${currentTime}
fi

cp -rf ${curr_dir}/ods_view_module ${curr_dir}/${mysql_table_name}_view

if  [ "$?" -ne "0" ]; then
   echo "Error22: copy ${tardir} error"
   exit 22;
fi


echo "-----------------------模板替换为目标---------------------------------------"
cd ${curr_dir}/${tardir}

crontab_script="crontab_${dwd_hive_table_name}.sh"
echo "${crontab_script}"
mv crontab_dwd_module.sh ${crontab_script}

crontab_to_ods_script="crontab_${dwd_hive_table_name}_to_ods.sh"
echo "${crontab_to_ods_script}"
mv crontab_dwd_module_to_ods.sh ${crontab_to_ods_script}

# 1. 创建ods_view层表
#sql_file="${ods_view_hive_table_name}.sql"
sql_file="view_ods_flume_json_db__table.sql"

if [ -f "$sql_file" ]; then
    rm -f $sql_file
fi
echo "drop view if exists ods_view.view_ods_flume_json_${mysql_db_name}__${mysql_table_name};">>${sql_file}
echo "CREATE VIEW \`ods_view.view_ods_flume_json_${mysql_db_name}__${mysql_table_name}\` AS select \`ods_flume_json_${mysql_db_name}__${mysql_table_name}\`.\`datelabel\`">>${sql_file}
echo ', `json`.`mysql_op_type`'>>${sql_file}
hive -e "use ods; desc ${ods_hive_table_name}" | awk '{print ",`json`.`"$1"`"}' >> ${sql_file}

echo "from \`ods\`.\`ods_flume_json_${mysql_db_name}__${mysql_table_name}\`">>${sql_file}
echo "lateral view json_tuple(\`ods_flume_json_${mysql_db_name}__${mysql_table_name}\`.\`json_str\`">>${sql_file}
echo ', "mysql_op_type"'>>${sql_file}
hive -e "use ods; desc ${ods_hive_table_name}" | awk '{print ",\""$1"\""}' >> ${sql_file}
#sed -i '2s:#:":g' ${sql_file}
echo ') `json` as `mysql_op_type`'>>${sql_file}
hive -e "use ods; desc ${ods_hive_table_name}" | awk '{print ",`"$1"`"}' >> ${sql_file}

# Todo 正式发布时放开
#hive -f ${curr_dir}/${sql_file}

# 2.替换dwd_db__table.sql
sed -i "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g"           dwd_db__table.sql
sed -i "s#__columns__#${columns}#g"                                   dwd_db__table.sql
sed -i "s#__primary_key__#${primary_key}#g"                           dwd_db__table.sql
sed -i "s#__ods_view_hive_table_name__#${ods_view_hive_table_name}#g" dwd_db__table.sql
sed -i "s#__ods_hive_table_name__#${ods_hive_table_name}#g"           dwd_db__table.sql
sed -i "s#__order_field__#${order_field}#g"                           dwd_db__table.sql

if  [ "$?" -ne "0" ]; then
   echo "Error22: 替换dwd_db__table.sql error"
   exit 22;
else
    echo "OK: 替换dwd_db__table.sql ok"
fi

# 3.替换dwd_db__table.sh
sed -i "s#__dwd_db__table__#dwd_${mysql_db_name}__${mysql_table_name}#g" dwd_db__table.sh

if  [ "$?" -ne "0" ]; then
   echo "Error22: 替换dwd_db__table.sh error"
   exit 22;
else
    echo "OK: 替换dwd_db__table.sh ok"
fi


# 4.替换 dwd_to_ods.sh
sed -i "s#__dwd_hive_table_name__#${dwd_hive_table_name}#g"           dwd_to_ods.sh
sed -i "s#__columns__#${columns}#g"                                   dwd_to_ods.sh
sed -i "s#__ods_hive_table_name__#${ods_hive_table_name}#g"           dwd_to_ods.sh

if  [ "$?" -ne "0" ]; then
   echo "Error22: 替换 dwd_to_ods.sh error"
   exit 22;
else
    echo "OK: 替换 dwd_to_ods.sh ok"
fi

# 5.替换 add_partitions.sql
sed -i "s#ods_flume_json_db__table#ods_flume_json_${mysql_db_name}__${mysql_table_name}#g"  add_partitions.sql

if  [ "$?" -ne "0" ]; then
   echo "Error22: 替换 add_partitions.sql error"
   exit 22;
else
    echo "OK: 替换 add_partitions.sql ok"
fi





