#!/usr/bin/env bash
declare -r g_curr_dir=$(cd `dirname $0`; pwd)

cd ${g_curr_dir}
source ./common_config.sh

p_currentDate=`date +%Y%m%d`
p_currentTime=`date +%H%M%S`

g_project_parent_dir="${1}"
g_project_dir="${2}"
g_project_name="${3}"
project_zip_name="${4}"

if [ "$#" -ne "4" ];then
    echo "参数错误 退出 !!"
    echo  "g_project_parent_dir : ${g_project_parent_dir}  g_project_dir : ${g_project_dir}  g_project_name :  ${g_project_name} project_zip_name : ${project_zip_name}"

fi
echo  "g_project_dir : ${g_project_dir}  g_project_name :  ${g_project_name} project_zip_name : ${project_zip_name}"




function get_project_info(){

    if !  [ -f "${project_id_backup}" ]; then
        echo "不存在文件 ： ${project_id_backup}"
        clean_back_file
        exit 1
    fi
    echo "project_i${project_id_backup}d_backup : ${project_id_backup}"
    cat ${project_id_backup}
    project_id_info=`cat ${project_id_backup}`
    project_id=$(cat "${project_id_backup}" | grep "^project_id" | awk -F '=' '{print $2}')

    echo "project_id : ${project_id}"

    if ! [ -f "${flow_ids_backup}"  ]; then
        echo "不存在文件 ： ${flow_ids_backup}"
        clean_back_file
        exit 1
    fi

    awk '1' ${flow_ids_backup} | while read line
    do
       flow_id=$(echo "$line" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
       if [ -z "${flow_id}" ]; then
         continue
       fi
       #echo "project_id : ${project_id} flow_id : ${flow_id} "
       get_flow_info "${project_id}" "${flow_id}"
    done

    if [ -f  "${project_cron_backup}" ] ; then
        echo "${project_cron_backup}"
        cat ${project_cron_backup}
    fi
}


function get_flow_info(){
    local l_project_id="${1}"
    local l_flow_id="${2}"
    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"
    echo "获取flow 信息..."
    echo "l_project_id : ${l_project_id}  l_flow_id : ${l_flow_id}"
    curl -k --get --data "session.id=${g_session_id}" \
    --data "ajax=fetchSchedule" \
    --data "projectId=${l_project_id}" \
    --data "flowId=${l_flow_id}" \
    "${g_base_url}"/schedule > "${l_tmp_file}" 2>&1

    if [ -f "${l_tmp_file}" ]; then
        cat  ${l_tmp_file} | grep "cronExpression"
    fi


     cron_expr_str=$(cat "${l_tmp_file}" |grep "cronExpression" | grep ":")
     local ret="$?"
     if ! [ "${ret}" -eq  "0" ] ; then
        cat "${l_tmp_file}"
     fi
    cron_expr=$(echo "${cron_expr_str}" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/,$//g' | sed 's/^[ \t]*//g' | tr -d '\r' | tr -d '\n')
    if [ -z "${cron_expr}" ]; then
        cat "${l_tmp_file}"
    fi
    echo "${l_flow_id}=${cron_expr}"
    echo "${l_flow_id}=${cron_expr}" >> ${project_cron_backup}
    rm -f ${l_tmp_file}
}

function clean_back_file(){

rm -f "${flow_ids_backup}"  "${project_id_backup}"

}


backup_flow_config

fetch_flows_from_project "${flow_ids_backup}"  "${g_project_name}" "${project_id_backup}"
cat ${flow_ids_backup}
cat ${project_id_backup}
get_project_info
clean_back_file








