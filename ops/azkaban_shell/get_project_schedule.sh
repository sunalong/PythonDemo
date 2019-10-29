#!/usr/bin/env bash
declare -r g_curr_dir=$(cd `dirname $0`; pwd)

cd ${g_curr_dir}
source ./common_config.sh




git_ssh_config_parse
get_sesion_id

function main(){

cd "${g_work_dir}"



zip_base_name=`cat ${g_work_dir}/last_project_dir.txt`

if  ! [ -d "${g_work_dir}/${zip_base_name}" ]; then
    echo "local_azkaban_flow_dir : ${zip_base_name} 不存在!!!,退出"
    exit 1
fi

echo "zip_base_name : ${zip_base_name}"
local_azkaban_flow_dir="${g_work_dir}/${zip_base_name}/${g_git_flow_dir_name}"
echo "local_azkaban_flow_dir : ${local_azkaban_flow_dir}"
cd "${local_azkaban_flow_dir}"
project_type_dirs=`ls`
echo "${project_type_dirs}"


for project_type_dir in ${project_type_dirs} ;do
    cd "${local_azkaban_flow_dir}"
    if ! [ -d "${project_type_dir}" ]; then continue ;fi


    # 这层目录是第一层目录，区分工程类型，如 giz,etl
    cd "${local_azkaban_flow_dir}/${project_type_dir}"
    project_business_dirs=`ls`
    for project_business_dir in ${project_business_dirs}; do
    
        # 这层目录是第二层目录，区分业务类型，如 hive,ftp,kafka,dm  
        cd "${local_azkaban_flow_dir}/${project_type_dir}"
        if ! [ -d "${project_business_dir}" ]; then continue ;fi
        echo "project_business_dir :  ${project_business_dir}"
        cd "${local_azkaban_flow_dir}/${project_type_dir}/${project_business_dir}"
        project_dirs=`ls`
        for project_dir in ${project_dirs} ; do
            cd "${local_azkaban_flow_dir}/${project_type_dir}/${project_business_dir}"
            if ! [ -d "${project_dir}" ]; then continue ;fi
            g_project_name="${project_dir}"

            g_project_dir="${local_azkaban_flow_dir}/${project_type_dir}/${project_business_dir}/${project_dir}"
            g_project_parent_dir="${local_azkaban_flow_dir}/${project_type_dir}/${project_business_dir}"


            project_zip_name="${g_project_name}_${currentDate}_${currentTime}.zip"

            echo "g_project_parent_dir : ${g_project_parent_dir}  g_project_business_dir : ${g_project_dir} g_project_business_name:  ${g_project_name}  project_zip_name : ${project_zip_name}"
            cd "${g_curr_dir}"; ./backup_schedule.sh "${g_project_parent_dir}" "${g_project_dir}" "${g_project_name}" "${project_zip_name}"
            #cd ${g_curr_dir};./config_schedule.sh  "${g_project_parent_dir}" "${g_project_business_dir}" "${g_project_business_name}" "${project_zip_name}"



        done



    done
done
}


main