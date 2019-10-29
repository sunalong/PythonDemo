#!/usr/bin/env bash
declare -r g_curr_dir=$(cd `dirname $0`; pwd)


cd ${g_curr_dir}
source ./common_config.sh


g_project_parent_dir="${1}"
g_project_dir="${2}"
g_project_name="${3}"
project_zip_name="${4}"


p_currentDate=`date +%Y%m%d`
p_currentTime=`date +%H%M%S`

flow_ids_old="${g_work_dir}/flow_ids_old_${g_project_name}_${p_currentDate}_${p_currentTime}.txt"
flow_ids_new="${g_work_dir}/flow_ids_new_${g_project_name}_${p_currentDate}_${p_currentTime}.txt"
flow_ids_add="${g_work_dir}/flow_ids_add_${g_project_name}_${p_currentDate}_${p_currentTime}.txt"


if [ "$#" -ne "4" ];then
    echo "参数错误 退出 !!"
    echo  "g_project_parent_dir : ${g_project_parent_dir}  g_project_dir : ${g_project_dir}  g_project_name :  ${g_project_name} project_zip_name : ${project_zip_name}"

fi
echo  "g_project_dir : ${g_project_dir}  g_project_name :  ${g_project_name} project_zip_name : ${project_zip_name}"


function upload_zip(){

    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"

    echo "------------------上传ZIP文件到工程---------------------------"
    echo "g_base_url : ${g_base_url},  parent_project_dir : ${g_project_parent_dir},   project_zip_name : ${project_zip_name}, g_session_id :    ${g_session_id}, g_project_name : ${g_project_name}  "
    curl -k -i -H "Content-Type: multipart/mixed" -X POST \
    --form "session.id=${g_session_id}" \
    --form 'ajax=upload' \
    --form "file=@${g_project_parent_dir}/${project_zip_name}" \
    --form "project=${g_project_name}" \
    "${g_base_url}"/manager > "${l_tmp_file}" 2>&1

     cat "${l_tmp_file}" | grep error | grep ":"
     ret="$?"
     echo "ret = $ret"
     if  [ "$ret" -eq "0" ]; then
         cat "${l_tmp_file}"
         echo "upload zip file Error"
         exit 1
     fi
    cat "${l_tmp_file}"

    rm -f ${l_tmp_file}
    echo "$?"
}


function fetch_schedule(){

    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"
    curl -k --get --data "session.id=XXXXXXXXXXXXXX" \
    --data "ajax=fetchSchedule" \
    --data "projectId=1&flowId=test" \
    "${g_base_url}"/schedule


}


function get_new_flow(){
    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"

    #flow_ids_add
    echo "检查是否有新曾流程  flow_ids_old  : ${flow_ids_old}  flow_ids_new :  ${flow_ids_new}"
    echo "${g_project_name}_${g_project_name}_${g_project_name}"
    if ! [ -f "${flow_ids_old}" ]; then
     cp "${flow_ids_new}" "${flow_ids_add}"
    else
     awk '1' ${flow_ids_new} | while read line
     do

       new_flow_id=$(echo "$line" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
       old_flow_id=$(grep -Fx "${new_flow_id}"  "${flow_ids_old}" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
       echo "flow_id:${new_flow_id},  old_flow_id:${old_flow_id},"
       if [ -z "${old_flow_id}" ]; then
          echo "新增流程:${new_flow_id},写入文件:${flow_ids_add}"
          echo "${new_flow_id}" >> "${flow_ids_add}"
       fi
     done

     if [ -f "${flow_ids_add}" ]; then
         cat "${flow_ids_add}"
     fi
    fi
}


function config_cron(){

     echo "开始配置CRON调度 : ${flow_ids_add} "
     if  !  [ -f "${flow_ids_add}" ]; then
        clean_tmp_file
        exit 0
     fi

     #每次都将最新的调度配置
     #awk '1' ${flow_ids_new} | while read line
     #仅配置新增加的流程
     awk '1' ${flow_ids_add} | while read line
     do
       flow_id=$(echo "$line" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')

       properties_name="${flow_id}.properties"
       #dist_file_dir
       echo "配置文件为: ${properties_name}"

       echo "在目录 : ${g_project_dir} 下找配置文件 : ${properties_name} "
       properties_dir_name=$(find "${g_project_dir}" -name "${properties_name}")

       if [ -z "${properties_dir_name}" ]; then
            echo "${flow_id} 没有找到配置文件 : ${properties_name}"
            continue
       fi
       echo "配置文件 ： ${properties_dir_name},配置内容为 :"
       cat ${properties_dir_name}
       flow_info=`cat ${properties_dir_name} | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g'`
       cron_expr=`echo "${flow_info}" | grep "^quartz_cron=" | awk -F '=' '{print $2}' | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g'`
       echo "获取到的 cron_expr : ${cron_expr}"
       ret="$?"
       if ! [ "$ret" -eq "0" ]; then
         echo "${flow_id} 没有找到cron 配置项"
         continue
       fi
       if [ -z "${cron_expr}" ]; then
         echo "${flow_id} 没有配置cron 表达式"
         continue
       fi
       echo "flow_id : ${flow_id} cron_expr :  ${cron_expr}"
       echo "调用函数: config_schedule "
       config_schedule "${flow_id}" "${cron_expr}" "${g_project_name}"

     done

}



function config_schedules(){
     if  !  [ -f "${flow_ids_add}" ]; then
        clean_tmp_file
        exit 0
     fi
     awk '1' ${flow_ids_new} | while read line
     do
       flow_id=$(echo "$line" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')

       ret="$?"
       if ! [ "$ret" -eq "0" ]; then
         echo "${flow_id}" >> "${flow_ids_add}"
       fi
     done

}


function clean_tmp_file(){

rm -f "${flow_ids_old}"  "${flow_ids_new}" "${flow_ids_add}"
cd "${g_curr_dir}"
cd ${g_work_dir}
echo "${zip_base_name}" > last_project_dir.txt
cd ${g_curr_dir}

}




fetch_flows_from_project "${flow_ids_old}" "${g_project_name}"
upload_zip
fetch_flows_from_project "${flow_ids_new}" "${g_project_name}"
get_new_flow
config_cron
clean_tmp_file

#将最新的工程信息写入文件，供备份用





