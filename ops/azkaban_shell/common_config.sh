#!/usr/bin/env bash

#
#
#



function git_ssh_config_parse(){
    declare  g_session_id=""
    declare  g_flow_ids=""
    declare  g_project_id=""

    git_ssh_info=`cat ./git_ssh.properties`
    export  g_git_base_dir=`echo "${git_ssh_info}" | grep "^git_base_dir" | awk -F '=' '{print $2}'`
    export  g_git_flow_dir=`echo "${git_ssh_info}" | grep "^git_flow_dir" | awk -F '=' '{print $2}'`
    export  g_ssh_user=`echo "${git_ssh_info}" | grep "^ssh_user" | awk -F '=' '{print $2}'`
    export  g_ssh_passwd=`echo "${git_ssh_info}" | grep "^ssh_passwd" | awk -F '=' '{print $2}'`
    export  g_ssh_host=`echo "${git_ssh_info}" | grep "^ssh_host" | awk -F '=' '{print $2}'`
    export  g_base_url=`echo "${git_ssh_info}" | grep "^base_url" | awk -F '=' '{print $2}'`
    export  g_work_dir=`echo "${git_ssh_info}" | grep "^work_dir" | awk -F '=' '{print $2}'`
    export  remote_work_dir=`echo "${git_ssh_info}" | grep "^remote_work_dir" | awk -F '=' '{print $2}'`

    export  currentDate=`date +%Y%m%d`
    export  currentTime=`date +%H%M%S`

    export  g_git_flow_dir_name=`basename ${g_git_flow_dir}`
    export  g_git_flow_base_dir=`dirname ${g_git_flow_dir}`

    export zip_base_name="${g_git_flow_dir_name}_${currentDate}_${currentTime}"
    export zip_name="${zip_base_name}.zip"

    export azkaban_flow_dir="${g_work_dir}/${zip_base_name}/${g_git_flow_dir_name}"



}

function get_sesion_id(){
    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"

    curl -k -X POST \
    -d action=login \
    -d username=azkaban \
    -d password=azkaban \
    "${g_base_url}" > "${l_tmp_file}" 2>&1

     session_id_str=$(cat "${l_tmp_file}" |grep "session.id" | grep ":")
     local ret="$?"
     if ! [ "${ret}" -eq  "0" ] ; then
        cat "${l_tmp_file}"
        exit 1
     fi
    g_session_id=$(echo "${session_id_str}" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/,$//g' | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
    if [ -z "${g_session_id}" ]; then
        cat "${l_tmp_file}"
        exit 1
    fi
    echo "${g_session_id}"
    export g_session_id="${g_session_id}"
    rm -f ${l_tmp_file}

}

function fetch_flows_from_project(){


    local l_flow_ids_file="${1}"
    local l_project_name="${2}"
    local l_project_id_file="${3}"


    echo "开始获取流程信息 ${l_flow_ids_file} ${l_project_name} ${l_project_id_file} "
    echo "开始获取 flows 列表  project_id ...  "
    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"
    local l_flows_file="/tmp/${FUNCNAME}_flows_${l_curr_pid}_${l_curr_time}.txt"
    echo "ajax call start ....."

    echo " g_session_id : ${g_session_id} l_sub_project_name : ${l_project_name}  g_base_url : ${g_base_url}  "
    curl -k --get --data "session.id=${g_session_id}" \
    --data "ajax=fetchprojectflows" \
    --data "project=${l_project_name}" \
     "${g_base_url}"/manager > "${l_tmp_file}" 2>&1

    echo "获取 flows 列表  project_id 标准输出"

    cat "${l_tmp_file}"



     echo "获取 project_id ..."
     cat "${l_tmp_file}" | grep projectId
     project_id_str=$(cat "${l_tmp_file}" | grep projectId)
     project_id=$(echo ${project_id_str} | awk -F ':' '{print $2}' | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
     g_project_id=${project_id}
     echo "project_id : ${project_id}"
     if ! [ -z "${l_project_id_file}" ];then
        echo "project_id=${project_id}" > "${l_project_id_file}"
     fi


     echo "获取 flowId  ..."
     cat "${l_tmp_file}" | grep flowId > "${l_flows_file}"
     sed -i 's/\"//g' "${l_flows_file}"

     # flowIds_str=$(cat "${l_tmp_file}" | grep flowId)
     cat "${l_flows_file}"
     echo "l_flow_ids_file : ${l_flow_ids_file}"
     awk '1' ${l_flows_file} | while read line
     do

       flow_id=$(echo "$line" | awk -F ':' '{print $2}' | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')
       echo ${flow_id} >> ${l_flow_ids_file}
     done


     if [ -f "${l_flow_ids_file}" ]; then
        cat ${l_flow_ids_file}
     else
        echo "没有获取到内容 ${l_flow_ids_file}"
     fi


     rm -f "${l_tmp_file}" "${l_flows_file}"

}

function config_schedule(){

    local l_flow="${1}"
    local l_cron="${2}"
    local l_sub_project_name="${3}"

    echo "开始配置调度...."
    echo "l_flow : ${l_flow} l_cron : ${l_cron} "

    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"
    curl -k  \
    -d ajax=scheduleCronFlow \
    -d projectName="${l_sub_project_name}" \
    -d flow="${l_flow}" \
    --data-urlencode cronExpression="${l_cron}" \
    -b "azkaban.browser.session.id=${g_session_id}" \
    "${g_base_url}"/schedule > "${l_tmp_file}" 2>&1
    echo ${l_curr_time}
    cat "${l_tmp_file}"
    rm -f ${l_tmp_file}
    ret="$?"
    echo "$ret"
}


function backup_flow_config(){

    flow_ids_backup="${g_work_dir}/flow_ids_backup_${currentDate}_${currentTime}.txt"
    project_id_backup="${g_work_dir}/project_id_backup_${currentDate}_${currentTime}.txt"
    project_cron_backup="${g_work_dir}/project_cron_backup-${currentDate}_${currentTime}.txt"

}


function ssh_key_add(){

    echo "增加KEY 到目标主机"
    expect << EOF
        set timeout 900;

        spawn ssh ${g_ssh_user}@${g_ssh_host};
        expect {
          "\[#$\]"     {send "\r" }
          "password:" {send  "${g_ssh_passwd}\r"}
          "(yes/no)?" {send "yes\r";exp_continue}
        }
        expect {
          "\[#$\]"     {send "\r" }
          "Permission" {exit 3 }
        }
        expect "\[#$\]";send "echo 'Hello world!'\r";
        expect "\[#$\]";send "exit\r";
        expect eof;
EOF

}






function git_pull(){

    echo ${g_git_flow_dir_name}
    echo ${g_git_flow_base_dir}


    if [ ! -d "${g_work_dir}" ]; then mkdir -p  ${g_work_dir}; fi

    sshpass_cmd=`which sshpass`


    "${sshpass_cmd}" -v -p "${g_ssh_passwd}" ssh "${g_ssh_user}"@"${g_ssh_host}" "source /etc/profile; cd ${g_git_base_dir}; git pull"
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "git pull  error exit !!!"; exit 1; fi
    "${sshpass_cmd}" -v -p "${g_ssh_passwd}" ssh "${g_ssh_user}"@"${g_ssh_host}" "source /etc/profile; if [ ! -d ${remote_work_dir} ]; then mkdir -p  ${remote_work_dir}; fi "
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "create remote dir  error exit !!!"; exit 1; fi
    "${sshpass_cmd}" -v -p "${g_ssh_passwd}" ssh "${g_ssh_user}"@"${g_ssh_host}" "source /etc/profile; cd ${g_git_flow_base_dir}; zip -r ${zip_name} ${g_git_flow_dir_name}"
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "remote package  error exit !!!";exit 1; fi
    "${sshpass_cmd}" -v -p "${g_ssh_passwd}" ssh "${g_ssh_user}"@"${g_ssh_host}" "source /etc/profile; cd ${g_git_flow_base_dir}; mv ${zip_name} ${remote_work_dir}"
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "move zip  error exit !!!"; exit 1;fi
    "${sshpass_cmd}" -v -p "${g_ssh_passwd}" scp "${g_ssh_user}"@"${g_ssh_host}":${remote_work_dir}/${zip_name} "${g_work_dir}"
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "scp zip  error exit !!!"; exit 1;fi
    #"${sshpass_cmd}" -v -p "${g_ssh_passwd}" ssh "${g_ssh_user}"@${g_ssh_host} "source /etc/profile; cd  ${remote_work_dir}; rm -f ${zip_name}"
     ret="$?"; if ! [ "$ret" -eq "0" ]; then echo "rm remote  zip  error exit !!!"; exit 1;fi
    cd ${g_work_dir}

    unzip -o ${zip_name} -d ${zip_base_name}

}
