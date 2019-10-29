#! /bin/bash

declare -r curr_dir=$(cd `dirname $0`; pwd)
SHELL_LOG_DIR=/var/log/sqoopload/sqoop
curr_date=`date +%Y%m%d`
curr_time=`date +%H%M%S`

if [ ! -d "${SHELL_LOG_DIR}" ]; then
  mkdir -p ${SHELL_LOG_DIR}
fi
logfile="shellMonitor_${curr_date}_${curr_time}.log"
file_path="${SHELL_LOG_DIR}/${logfile}"
file_bak="${file_path}_bak_${curr_date}_${curr_time}"
if [ -f "${file_path}" ];then
    mv $file_path $file_bak
fi

PYTHONPATH=$(cd `dirname $0`/../../../../; pwd)
export PYTHONPATH=$PYTHONPATH

#source ~/.py2_env/bin/activate
#source ~/.py3_env/bin/activate
source /data/soft/py3__env/bin/activate
#nohup python ${curr_dir}/sqoopLogWarn.py >> "${file_path}"  2>&1
#python ${curr_dir}/sqoopLogWarn.py >> "${file_path}"  2>&1
python ${curr_dir}/sqoopLogWarn.py &>"${file_path}"
deactivate
