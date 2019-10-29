#!/usr/bin/env bash

script_path_file=$0
#echo "$script_path_file"
if [ -L ${script_path_file} ]; then
    script_path_file=`ls -al $0 | awk -F '->' '{print $2}' |  tr -d '\n' | sed s/[[:space:]]//g`
    #echo "script_path_file = ${script_path_file}"
fi
#echo "script_path_file = ${script_path_file}"
declare -r curr_dir=$(cd `dirname ${script_path_file}`; pwd)

export PYTHONPATH=`dirname ${curr_dir}`

export CURR_DIR=${curr_dir}
source /data/soft/py3_rongtong_env/bin/activate

#echo "输入参数："
#echo "$@"


python /data/soft/get_rongtong_host/SqlServerDriver.py "$@"