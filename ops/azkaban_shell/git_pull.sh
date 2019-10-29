#!/usr/bin/env bash


declare -r curr_dir=$(cd `dirname $0`; pwd)
currentDate=`date +%Y%m%d`
currentTime=`date +%H%M%S`

git_dir="/data/app/test/bi-center"
project_dir="/data/app/test/bi-center/etl/azkaban_flow"
remote_work_dir="/tmp/remote_git_jenkins"
local_work_dir="/tmp/local_git_jenkins"
project_tar_dir=`basename ${project_dir}`
project_base_dir=`dirname ${project_dir}`





zip_base_name="${project_tar_dir}_${currentDate}_${currentTime}"
zip_name="${zip_base_name}.zip"
remote_project_work="${remote_work_dir}/${project_tar_dir}"
local_project_work="${local_work_dir}/${project_tar_dir}"

dist_file_dir="${local_project_work}/${zip_base_name}/${project_tar_dir}"



echo ${project_base_dir}
echo ${project_tar_dir}


if [ ! -d "${local_project_work}" ]; then mkdir -p  ${local_project_work}; fi

sshpass_cmd=`which sshpass`


"${sshpass_cmd}" -p 123456 ssh hadoop@192.168.175.134 "source /etc/profile; cd $git_dir; git pull"
"${sshpass_cmd}" -p 123456 ssh hadoop@192.168.175.134 "source /etc/profile; if [ ! -d "${remote_work_dir}" ]; then mkdir -p  ${remote_work_dir}; fi  "
"${sshpass_cmd}" -p 123456 ssh hadoop@192.168.175.134 "source /etc/profile; cd ${project_base_dir}; zip -r ${zip_name} ${project_tar_dir}"
"${sshpass_cmd}" -p 123456 ssh hadoop@192.168.175.134 "source /etc/profile; cd ${project_base_dir}; mv ${zip_name} ${remote_work_dir}"
"${sshpass_cmd}" -p 123456 scp hadoop@192.168.175.134:${remote_work_dir}/${zip_name} "${local_project_work}"
#"${sshpass_cmd}" -p 123456 ssh hadoop@192.168.175.134 "source /etc/profile; cd  ${remote_work_dir}; rm -f ${zip_name}"

cd ${local_project_work}

unzip -o ${zip_name} -d ${zip_base_name}








