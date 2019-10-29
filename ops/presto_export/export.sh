#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)


#sql_file_path="/data/user/sqoop/export/sql"
sql_file_path="/Users/along/YH/PY_Tools/com/itcode/ops/presto_export/sql"

sql_file_list=${curr_dir}/sql_file_list


# Todo:每分钟 遍历目录，while sleep 1m
# Todo:如果以 .sql 结尾，执行sql文件
# Todo:执行完毕后，添加后缀 _ok

#source /data/soft/py3__env/bin/activate
source ~/.py3_env/bin/activate

while :
do
    # 1.检查目录下的文件，过滤 .sql后缀的文件到 sql_file_list 文件中
    find ${sql_file_path} -name "*.sql" > ${sql_file_list}

    # 2.遍历 sql_file_list 文件，执行文件
    for line in `cat ${sql_file_list}`;do
        echo line:$line
        file_path=${line%/*}
        file_path_and_name=${line%%.*}
        echo file_path:${file_path}
        file_no_suffix=`basename $line .sql`
        excel_file="${file_path}/../excel/${file_no_suffix}".xlsx
        excel_md5_file="${file_path}/../excel/${file_no_suffix}".md5

        echo start_date=`date +%H:%M:%S`
        python ${curr_dir}/ExportExcel.py ${file_path_and_name} &>${curr_dir}/export.log
        echo end_date=`date +%H:%M:%S`

        ret=$?
        if [ ${ret} -eq 0 ]; then
            md5sum ${excel_file} |cut -d ' ' -f1 >${excel_md5_file}
            # 3.执行完毕后，添加后缀 _ok
#            mv ${line} ${line}_ok
        fi
    done
    echo currentTime_1=`date +%H:%M:%S`
    sleep 1m #每一分钟检查一下目录
    echo currentTime_2=`date +%H:%M:%S`
done


deactivate
