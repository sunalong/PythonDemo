#!/usr/bin/env bash

declare -r g_curr_dir=$(cd `dirname $0`; pwd)


sshpass -p 123456 scp ${g_curr_dir}/*.sh sqoop@work-study-04:/data/soft/azkaban_shell
sshpass -p 123456 ssh sqoop@work-study-04 "source /etc/profile; cd /data/soft/azkaban_shell; chmod +x *.sh"


#sshpass -p Ujm123#! scp ${g_curr_dir}/*.sh sqoop@uhadoop-mzwc2w-task3:/data/soft/azkaban_shell
#sshpass -p Ujm123#! ssh sqoop@uhadoop-mzwc2w-task3 "source /etc/profile; cd /data/soft/azkaban_shell; chmod +x *.sh"

sshpass -p Ujm123#! scp ${g_curr_dir}/*.sh sqoop@10.10.64.79:/data/soft/azkaban_shell
sshpass -p Ujm123#! ssh sqoop@10.10.64.79 "source /etc/profile; cd /data/soft/azkaban_shell; chmod +x *.sh"
