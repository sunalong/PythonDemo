#! /bin/bash -x 

declare -r curr_dir=$(cd `dirname $0`; pwd)
SQOOP_LOG_DIR=/var/log/sqoopload
curr_date=`date +%Y%m%d`
curr_time=`date +%H%M%S`
sname=`basename $0`
tmp_name=${sname#*_}
tabname=${tmp_name%.*}
logdir="${SQOOP_LOG_DIR}/$tabname"
if [ ! -d "${logdir}" ]; then
  mkdir -p $logdir
fi
logfile="${tabname}_${curr_date}.log"

filepath="${logdir}/${logfile}"
file_bak="${filepath}_bak_${curr_date}_${curr_time}"
if [ -f "${filepath}"  ]; then
    mv $filepath $file_bak
fi

nohup $curr_dir/union.sh >> $filepath 2>&1 &

