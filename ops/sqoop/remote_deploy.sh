#!/bin/bash

declare -r work_dir=$(cd `dirname $0`; pwd)
declare -r parent_dir=`dirname ${work_dir}`

function cp_file(){
  local l_hostip=${1}
  local l_uasername=${2}
  local l_passwd=${3}
  local l_remotedir=${4}
  local l_localdir=${5}
  local l_mputfile=${6}
  echo "拷贝文件到远程主机"
  echo "参数个数:$# 参数列表:$@"
	expect -c "
	  set timeout 30000;
    spawn sftp ${l_uasername}@${l_hostip};
    expect {
      \"\sftp>\"    {send \"\r\" }
      \"password:\" {send  \"${l_passwd}\r\"}
      \"(yes/no)?\" {send \"yes\r\";exp_continue}
    }
    expect {
      \"sftp>\"     {send \"\r\" }
      \"Permission\" {exit 3 }
    }
    expect \"sftp>\";send \"cd ${l_remotedir}\r\";
    expect \"sftp>\";send \"lcd ${l_localdir}\r\";
    expect \"sftp>\";send \"${l_mputfile}\r\";
    expect \"sftp>\";send \"exit\r\";
    expect eof;"
}

function add_exec(){
  local l_hostip=${1}
  local l_uasername=${2}
  local l_passwd=${3}
  local l_remotedir=${4}

  echo "给脚本增家执行权限"
  echo "参数个数:$# 参数列表:$@"
	expect -c "
	  set timeout 30000;
    spawn ssh ${l_uasername}@${l_hostip};
    expect {
      \"\[#$\]\"    {send \"\r\" }
      \"password:\" {send  \"${l_passwd}\r\"}
      \"(yes/no)?\" {send \"yes\r\";exp_continue}
    }
    expect {
      \"\[#$\]\"     {send \"\r\" }
      \"Permission\" {exit 3 }
    }
    expect \"\[#$\]\";send \"cd ${l_remotedir}\r\";
    expect \"\[#$\]\";send \"rm -rf shellMonitor*\r\";
    expect \"\[#$\]\";send \"exit\r\";
    expect eof;"
}


cd /root/PycharmProjects/hiveMonitor;
rm -f shellMonitor.tar.gz
tar zcvf  shellMonitor.tar.gz  shellMonitor
cd "${work_dir}"

add_exec "10.9.196.220" "sqoop" "Ujm123#!" "/data/monitor/hiveMonitor"
cp_file "10.9.196.220" "sqoop" "Ujm123#!" "/data/monitor/hiveMonitor" "/root/PycharmProjects/hiveMonitor" "mput shellMonitor.tar.gz"
#add_exec "10.9.196.220" "sqoop" "Ujm123#!" "/data/monitor/hiveMonitor"
#cp_file "10.9.196.220" "sqoop" "Ujm123#!" "/data/monitor/hiveMonitor" "/home/neo/PycharmProjects/hiveMonitor" "mput shellMonitor.tar.gz"


