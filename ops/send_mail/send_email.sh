#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)

declare -r curr_dir=$(cd `dirname $0`; pwd)
cd ${curr_dir}
project_name=$(basename `pwd`)
echo project_name111111:$project_name


today=`date -d " -1 day " +%Y-%m-%d`
# 1.调用 gen_file.sh 来执行sql脚本，生成结果文件
/bin/bash -x ${curr_dir}/../../get_result.sh $0 $today &>${curr_dir}/get_result.log


ret=$?
productorTel=`sed -n /^productorTel/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'|sed s/,/\",\"/g`
if [ "${ret}" -ne "0" ]; then
    echo "执行hive脚本失败，开始报警"
#    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=369a3660-993b-437d-a78c-bcf84e442aaf' \
#    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=892af622-b2cc-41a3-897f-f59ee52bc5fc' \
     curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=77463d0b-b2bb-4955-802b-c9ff04fa2df6' \
       -H 'Content-Type: application/json' \
       -d '
       {
            "msgtype": "text",
            "text": {
                "content": "'"$project_name"' 任务失败，请处理",
                "mentioned_mobile_list":["'"$productorTel"'"]
            }
       }'
    exit 30
fi

# 2.调用 python 脚本，将邮件发送出去

PYTHONPATH=$(cd `dirname $0`/../../../../; pwd)
export PYTHONPATH=$PYTHONPATH
source /data/soft/py3__env/bin/activate
#source ~/.py3_env/bin/activate
python ${curr_dir}/../../mailSend.py ${curr_dir}/conf.ini &>>${curr_dir}/get_result.log

ret=$?
echo $ret
productorTel=`sed -n /^productorTel/p ${curr_dir}/conf.ini | awk 'BEGIN{OFS=",";FS="['=']"} {print $2}'|sed s/,/\",\"/g`
echo $productorTel >>${curr_dir}/get_result.log
if [ "${ret}" -ne "0" ]; then
    echo "邮件发送失败，开始报警"
#    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=369a3660-993b-437d-a78c-bcf84e442aaf' \
#    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=892af622-b2cc-41a3-897f-f59ee52bc5fc' \
    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=77463d0b-b2bb-4955-802b-c9ff04fa2df6' \
       -H 'Content-Type: application/json' \
       -d '
       {
            "msgtype": "text",
            "text": {
                "content": "'"$project_name"' 邮件发送失败,有可能是附件大于50MB,请处理",
                "mentioned_mobile_list":["'"$productorTel"'"]
            }
       }'
    exit 30
#else
##    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=369a3660-993b-437d-a78c-bcf84e442aaf' \
##    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=892af622-b2cc-41a3-897f-f59ee52bc5fc' \
#    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=77463d0b-b2bb-4955-802b-c9ff04fa2df6' \
#       -H 'Content-Type: application/json' \
#       -d '
#       {
#            "msgtype": "text",
#            "text": {
#                "content": "'"$project_name"' 邮件发送成功，请查收",
#                "mentioned_mobile_list":["'"$productorTel"'"]
#            }
#       }'
fi
deactivate