#!/usr/bin/env bash
declare -r g_curr_dir=$(cd `dirname $0`; pwd)

cd ${g_curr_dir}
source ./common_config.sh



function get_last_back(){

    echo "${project_cron_backup}"
    backup_file_prefix=$(basename ${project_cron_backup} | awk -F '-' '{print $1}')
    echo ${backup_file_prefix}

    last_back_file=$(find ${local_work_dir} -name "${backup_file_prefix}*.txt" | xargs ls -rlt | tail -1 | awk  '{print $9}')

    echo "最近备份的文件为：${last_back_file}"
    if  ! [ -f "${last_back_file}" ] ; then
        echo "文件不存在 ： ${last_back_file}"
        exit 1
    fi

    if ! [ -s "${last_back_file}" ] ; then
        echo "文件为空 ： ${last_back_file}"
        exit 1
    fi
    restore_schedule  "${last_back_file}"
}

function restore_schedule(){

    local l_last_back_file="${1}"

    awk '1' ${l_last_back_file} | while read line
    do

       if [ -z "${line}" ]; then
        continue
       fi
       flow_id=$(echo "$line" | tr -d '\r' | tr -d '\n' | sed 's/[[:space:]]//g')

       flow_id=$(echo "${line}" | awk -F '=' '{print $1}')
       cron_expr=$(echo "${line}" | awk -F '=' '{print $2}')

       if [ -z "${flow_id}" -o -z "${cron_expr}" ]; then
         continue
       fi
       config_schedule  "${flow_id}"  "${cron_expr}"
    done
}


git_ssh_config_parse
backup_flow_config
get_sesion_id
get_last_back