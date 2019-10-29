#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)

declare -r curr_dir=$(cd `dirname $0`; pwd)
cd ${curr_dir}
project_name=$(basename `pwd`)
echo project_name111111:$project_name


today=`date -d " -1 day " +%Y-%m-%d`

PYTHONPATH=$(cd `dirname $0`/../../../../; pwd)
export PYTHONPATH=$PYTHONPATH
source /data/soft/py3__env/bin/activate
#source ~/.py3_env/bin/activate
python ${curr_dir}/read_mysql_create_project.py $0 &>${curr_dir}/rmcp.log

deactivate
