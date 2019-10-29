#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo "FuckMe":`date`

#sql_file=$1
sql_file=lala.sql
echo sql_file:${sql_file} &>${curr_dir}/log.log
# Todo:将sql文件复制到远程机器
echo "sshpass -p yh66#bymjh scp ${curr_dir}/../sql/${sql_file} sqoop@10.9.196.220:/data/soft/data_platform_export/sql/${sql_file} &>> ${curr_dir}/log.log"
sshpass -p yh66#bymjh scp ${curr_dir}/../sql/${sql_file} sqoop@10.9.196.220:/data/soft/data_platform_export/sql/${sql_file}
# Todo:调用远程机器上的脚本，执行结果，并将结果文件返回来
sshpass -p yh66#bymjh ssh sqoop@10.9.196.220 "source /etc/profile; bash -x /data/soft/data_platform_export/export.sh ${sql_file}"




