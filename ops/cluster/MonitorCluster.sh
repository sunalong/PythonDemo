#! /bin/bash -x
#使用示例：
# 先向表中插入更新后的数据条数：
#./MonitorDwd.sh i dwd_order_db__t_trade_order_item

# 再查询表中数据条数的波动比，并以此来报警：
#  MonitorDwd i dwd_order_db__t_trade_order_item
#  MonitorDwd j dwd_order_db__t_trade_order_item

script_path_file=$0
echo "参数1是方法：" $1
echo "参数2是表名：" $2

if [ $1 == i ];then
    method=insertToMysql
elif [ $1 == j ];then
    method=judge
fi


echo "$script_path_file"
if [ -L ${script_path_file} ]; then
    script_path_file=`ls -al $0 | awk -F '->' '{print $2}' |  tr -d '\n' | sed s/[[:space:]]//g`
    echo "script_path_file1 = ${script_path_file}"
fi
echo "script_path_file2 = ${script_path_file}"
#declare -r curr_dir=$(cd `dirname ${script_path_file}`; pwd)
curr_dir=$(cd `dirname ${script_path_file}`; pwd)
echo curr_dir: ${curr_dir}
PYTHONPATH=$(cd `dirname ${script_path_file}`/../../../../; pwd)
export PYTHONPATH=${PYTHONPATH}
#export PYTHONPATH=/data/soft/PY_Tools/
#export PYTHONPATH=/Users/along/YH/PY_Tools

#export CURR_DIR=${curr_dir}
#source /data/soft/py3_check_env/bin/activate
#source /data/user/wangyf/py3_email/email/bin/activate
source /data/soft/py3__env/bin/activate
#echo "输入参数："
#echo "$@"



#python ${curr_dir}/MonitorDwd.py  ${method} $2
python ${curr_dir}/MonitorCluster.py

deactivate
