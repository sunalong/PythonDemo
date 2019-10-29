#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
echo curr_dir:$curr_dir


bash ${curr_dir}/get_dwd_table_info.sh
ret=$?
if [ "$ret" -eq "0" ] ; then
    bash ${curr_dir}/judge_dwd_table.sh &>${curr_dir}/judge_dwd_table.log
fi


