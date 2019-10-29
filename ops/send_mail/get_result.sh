#! /bin/bash -x

echo 11111:$1

#declare -r curr_dir=$(cd `dirname $0`; pwd)
declare -r curr_dir=$(cd `dirname $1`; pwd)
cd ${curr_dir}
#project_name=$(basename `pwd`)
project_name=$(basename ${curr_dir})
echo project_name:$project_name
#sql_head="INSERT OVERWRITE LOCAL DIRECTORY '${curr_dir}/data' ROW FORMAT DELIMITED FIELDS TERMINATED BY ','  "
#
#echo ${sql_head} >${curr_dir}/gen_sql.sql
#cat ${curr_dir}/exec.sql >>${curr_dir}/gen_sql.sql
#
##替换 sql 脚本中的日期
#sed -i "s/__execute_date__/$2/g" ${curr_dir}/gen_sql.sql


hive -f ${curr_dir}/gen_sql.sql
ret=$?
if [ "${ret}" -ne "0" ]; then
    echo "执行hive脚本失败，开始报警"
    exit 30
fi

cat ${curr_dir}/data/0* >${curr_dir}/data/all
# 按 50MB 大小来切分文件,按大小切分会损坏csv格式，需要按列切分
split -l 200000 -d ${curr_dir}/data/all  ${curr_dir}/data/fuckme
#split -b 50m -d ${curr_dir}/data/all  ${curr_dir}/data/fuckme

#done:重命名切分后的文件
cd ${curr_dir}/data
for i in `ls`;do mv -f $i `echo $i | sed "s/^fuckme/\${project_name}/"`.csv;done


fields_comment=`sed -n /^fields_comment/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'`
#fields_comment=`sed -n /^fields_comment/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'|sed "s#,#\t#g"`

for i in `ls`;do  sed -i "1i\\${fields_comment}" $i;done

#done:压缩文件
curr_date=`date +%Y%m%d`
zip ${project_name}_${curr_date}.zip ${project_name}*
#unzip getshop.zip 解压
ret=$?
if [ "${ret}" -ne "0" ]; then
    echo "任务失败，开始报警"
    exit 30
fi
exit $ret

