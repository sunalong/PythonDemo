#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo curr_dir:$curr_dir
# 查找库目录
#find /data/app/dev/data_biz/etl/ -type d -name member_center 2>/dev/null
#/data/app/dev/data_biz/etl/ods110/member_center
#/data/app/dev/data_biz/etl/ods83/member_center
#/data/app/dev/data_biz/etl/member_center

#为当前目录下所有sh脚本添加执行权限
#find ./ -name "*.sh" |xargs ls |xargs chmod +x

mysql_host=`sed -n /^mysql_host/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
mysql_port=`sed -n /^mysql_port/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
mysql_db_name=`sed -n /^mysql_db_name/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
mysql_table_name=`sed -n /^mysql_table_name/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
primary_key=`sed -n /^primary_key/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
order_field=`sed -n /^order_field/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
mr_count=`sed -n /^mr_count/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
username=`sed -n /^username/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
productor=`sed -n /^productor/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
status=`sed -n /^status/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
username=`sed -n /^username/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`


# 执行etl.sh ,在 ${curr_dir}/init_module 目录下生成抽数脚本文件
bash ${curr_dir}/init_module/etl.sh  ${mysql_host} ${mysql_port} ${mysql_db_name} ${mysql_table_name} ${primary_key} ${order_field} ${mr_count} ${username}

# Done:将生成的抽数脚本文件 复制到 /data/app/dev/data_biz/etl/xxx_db_name 目录下

# 只有在etl直接目录下的是合法的,如果没有,则创建
db_dir="/data/app/dev/data_biz/etl/"${mysql_db_name}
if [ ! -d "${db_dir}" ];then
    echo "没有目录："${db_dir}
    mkdir ${db_dir}
else
    echo "目录存在："${db_dir}
fi

#rm -rf ${db_dir}/
mv ${curr_dir}/init_module/ods_flume_json_${mysql_db_name}__${mysql_table_name} ${db_dir}/
mv ${curr_dir}/init_module/${mysql_table_name}                                  ${db_dir}/
mv ${curr_dir}/init_module/${mysql_table_name}_view                             ${db_dir}/
mv ${curr_dir}/init_module/dwd_${mysql_db_name}__${mysql_table_name}.sql        ${db_dir}/
mv ${curr_dir}/init_module/dwd_${mysql_db_name}__${mysql_table_name}_tmp.sql    ${db_dir}/
