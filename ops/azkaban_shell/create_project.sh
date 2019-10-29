#!/usr/bin/env bash


# a 前缀表示绝对目录
# r 前缀表示相对目录
# g 前缀表示全局变量
# l 前缀表示函数本地变量



declare -r g_curr_dir=$(cd `dirname $0`; pwd)

cd ${g_curr_dir}
source ./common_config.sh


#如果工程已经存在则不会再次创建
function create_project(){
    local l_sub_project_name="${1}"
    local l_description="${2}"
    local l_curr_pid="$$"
    local l_curr_time=$(date +%Y%m%d%H%M%S%N)
    local l_tmp_file="/tmp/${FUNCNAME}_${l_curr_pid}_${l_curr_time}.txt"

    echo "创建工程 : l_sub_project_name : ${l_sub_project_name}  l_description : ${l_description}"
    curl -k -X POST \
    --data "session.id=${g_session_id}" \
    --data "name=${l_sub_project_name}" \
    --data "description=${l_description}" \
    ${g_base_url}/manager?action=create > "${l_tmp_file}" 2>&1

    cat "${l_tmp_file}"

    rm -f "${l_tmp_file}"
}


git_ssh_config_parse
git_pull
ssh_key_add
get_sesion_id

function main(){

if  [ -z "${azkaban_flow_dir}" ]; then
    echo "azkaban_flow_dir : ${azkaban_flow_dir} 不存在!!!,退出"
    exit 1
fi

echo "azkaban_flow_dir : ${azkaban_flow_dir}"
echo "进入azkaban_flow_dir : ${azkaban_flow_dir}"
cd "${azkaban_flow_dir}"
r_first_dirs=`ls`
echo "第一层目录共有如下目录 : ${r_first_dirs}"
for r_first_dir in ${r_first_dirs} ;do

    cd "${azkaban_flow_dir}"
    if ! [ -d "${r_first_dir}" ]; then continue ;fi
    echo "进入第一层目录 : ${azkaban_flow_dir}/${r_first_dir}"
    cd "${azkaban_flow_dir}/${r_first_dir}"
    r_second_dirs=`ls`
    echo "第二层目录共有如下目录 ： $r_second_dirs"
    for r_second_dir in ${r_second_dirs}; do
        cd "${azkaban_flow_dir}/${r_first_dir}"
        echo "r_second dir : ${r_second_dir}"
        if ! [ -d "${r_second_dir}" ]; then continue ;fi
        echo "进入第二层目录 : ${azkaban_flow_dir}/${r_first_dir}/${r_second_dir}"
        cd "${azkaban_flow_dir}/${r_first_dir}/${r_second_dir}"
        r_project_dirs=`ls`
        echo "第二层目录下有如下工程目录 :  $r_project_dirs"
        for r_project_dir in ${r_project_dirs}; do
            cd "${azkaban_flow_dir}/${r_first_dir}/${r_second_dir}"
            if ! [ -d "${r_project_dir}" ]; then continue ;fi
            echo "该目录为工程目录 :  ${r_project_dir}"
            g_project_name="${r_project_dir}"
            description=""
            g_a_project_dir="${azkaban_flow_dir}/${r_first_dir}/${r_second_dir}/${r_project_dir}/"
            project_description_file="${g_a_project_dir}/README.md"
            if [ -f "${project_description_file}" ]; then
                description=`cat "${project_description_file}" | grep "^description" | awk -F '=' '{print $2}'`
            fi

            if [ -z "${description}" ]; then
                    description="该工程没有添加描述"
            fi
            g_a_project_parent_dir="${azkaban_flow_dir}/${r_first_dir}/${r_second_dir}"
            project_zip_name="${g_project_name}_${currentDate}_${currentTime}.zip"

            zip -r ${project_zip_name} ${g_project_name}
            create_project  "${g_project_name}" "${description}"
            cd ${g_curr_dir};./config_schedule.sh  "${g_a_project_parent_dir}" "${g_a_project_dir}" "${g_project_name}" "${project_zip_name}"

        done
    done
done
}


main

