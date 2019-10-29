#! /bin/bash -x
# 声明并进入到当前目录
declare -r curr_dir=$(cd `dirname $0`; pwd)
# 本脚本每天凌晨之前定时更新 tab.cfg 文件，供sqoop日志报警程序来使用

# Done: 去除行首、尾空格
crontab -l > ${curr_dir}/crontab.txt
#setsid script -c 'sudo awk \'gsub(/^ *| *$/,"")\' /var/spool/cron/sqoop' >${curr_dir}/trim_sqoop
awk 'gsub(/^ *| *$/,"")' ${curr_dir}/crontab.txt >${curr_dir}/trim_sqoop

# Done: 去除含有 > 的不符合规范的行
sed -e '/>/d' ${curr_dir}/trim_sqoop >${curr_dir}/standard_sqoop

# Todo: 将含有，的行 如：00 10,22 变为两行
# 另，以逗号作为分隔符，只取逗号之前的列

# Done：去除以# 开头的行，将数据重定向到文件中
awk -F '[, /]'  '/^#/{next};{split($NF,b,".");len=length("'${b[1]}'");print $2":"$1":00 "substr(b[1],9,length(b[1])-8) }' ${curr_dir}/standard_sqoop >${curr_dir}/tab.cfg

# 删除中间文件
#rm ${curr_dir}/trim_sqoop ${curr_dir}/standard_sqoop ${curr_dir}/crontab.txt