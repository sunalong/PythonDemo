#!/bin/bash 

declare -r curr_dir=$(cd `dirname $0`; pwd)

source /data/soft/py3__env/bin/activate

if [ '--help' == "$1" ]; then 
  python ${curr_dir}/exception_alert.py --help
fi

python ${curr_dir}/exception_alert.py --msg "$2" --group "$4"

deactivate
