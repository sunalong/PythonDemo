#! /bin/bash -x
declare -r curr_dir=$(cd `dirname $0`; pwd)

# 一：获取application 的信息
/bin/bash -x ${curr_dir}/get_application_info.sh &>${curr_dir}/get_info.log

# 二：生成将application信息插入sql的脚本
PYTHONPATH=$(cd `dirname $0`/../../../../; pwd)
export PYTHONPATH=$PYTHONPATH
source /data/soft/py3__env/bin/activate

python ${curr_dir}/insert_to_mysql.py
deactivate

# 三：执行sql脚本，将数据插入到表ods中，并etl
/bin/bash -x ${curr_dir}/etl.sh &>${curr_dir}/etl.log
