#! /bin/bash -x

while read line;do
        ip=`echo $line | cut -d " " -f1`             # 提取文件中的ip
        user_name=`echo $line | cut -d " " -f2`      # 提取文件中的用户名
        pass_word=`echo $line | cut -d " " -f3`      # 提取文件中的密码
expect <<EOF
#        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $user_name@$ip   # 复制公钥到目标主机
        spawn ssh-copy-id -i  /Users/along/.ssh/id_rsa.pub $user_name@$ip
        # 复制公钥到目标主机
        expect {
                "yes/no" { send "yes\n";exp_continue}
                # expect 实现自动输入密码
                "password" { send "$pass_word\n"}
        }
        expect eof
EOF

done < ./host_name_passwd2.txt      # 读取存储ip的文件

#pscp.pssh -h /root/host_ip.txt /root/your_scripts.sh /root     # 推送你在目标主机进行的部署配置
#pssh -h /root/host_ip.txt -i bash /root/your_scripts.sh        # 进行远程配置，执行你的配置脚本

