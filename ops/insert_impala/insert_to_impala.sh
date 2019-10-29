#! /bin/bash -x
declare -r curr_dir=$(cd `dirname $0`; pwd)

# 一：从 hdfs中导出数据到指定目录
sql="""
        insert overwrite local directory './hdfs_data'
        row format delimited
        fields terminated by '\t'
        select *
        from dm.dm_yh_member_wide_table
        where sdt ='20190514';
"""
echo "sql:" $sql
rm ./hdfs_data/*
hive -e "${sql}"
cat ./hdfs_data/00* >./hdfs_data/dest_file

# 二：执行 python 命令，切分文件并按格式写到多个文件中
source /data/soft/py3__env/bin/activate
python ${curr_dir}/insert-impala.py
deactivate

# 三：遍历切分好的目录文件，将数据导入到impala

for file in ${curr_dir}/seg_file_to_insert/*
do
	if [ -f $file ]
	then
		echo $file is a file
        impala-shell   -i 10.19.144.247:21000 -f ${file}
	fi
done
