#!/usr/bin/env bash

declare -r g_curr_dir=$(cd `dirname $0`; pwd)





#sshpass -p Ujm123#! scp ${g_curr_dir}/* sqoop@ycbi-db-01:/data/soft/rongtong
#sshpass -p Ujm123#! ssh sqoop@ycbi-db-02 "source /etc/profile; cd /data/soft/rongtong; chmod +x *.py ;chmod +x *.sh"

#sshpass -p Ujm123#! scp ${g_curr_dir}/* sqoop@ycbi-db-01:/data/soft/rongtong
#sshpass -p Ujm123#! ssh sqoop@ycbi-db-02 "source /etc/profile; cd /data/soft/rongtong; chmod +x *.py ;chmod +x *.sh"

#sshpass -p Ujm123#! scp ${g_curr_dir}/* sqoop@10.10.64.79:/data/soft/rongtong
#sshpass -p Ujm123#! ssh sqoop@10.10.64.79 "source /etc/profile; cd /data/soft/rongtong; chmod +x *.py ;chmod +x *.sh"



sshpass -p Ujm123#! scp ${g_curr_dir}/* sqoop@10-10-64-79:/data/soft/get_rongtong_host
sshpass -p Ujm123#! ssh sqoop@10-10-64-79 "source /etc/profile; cd /data/soft/get_rongtong_host; chmod +x *.py ;chmod +x *.sh"

