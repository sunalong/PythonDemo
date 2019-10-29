
#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
app_list_file="${curr_dir}/data/all_applist.txt"
app_info_file="${curr_dir}/data/app_info.txt"

line_split=2000  #每100行切分成一个文件
function split_file(){
    app_list_file=$1
    linenum=`wc -l ${app_list_file} | awk '{print $1}'`
    n1=1
    file_num=1
    while [ $n1 -lt $linenum ]
    do
        n2=`expr $n1 + $line_split`
        sed -n "${n1}, ${n2}p" ${app_list_file} > app_list_$file_num.txt
        n1=`expr $n2 + 1`
        file_num=`expr $file_num + 1`
    done
    return `expr $file_num - 1`
}

function get_status(){
    current_app_list_file=app_list_${1}.txt
    current_app_info_file=app_info_${1}.txt
    while read line;do
        echo line:${current_app_list_file}  $line
        # 行上的信息切割后转置到列上
        yarn application -status $line |awk -F ' : ' '{ for(i=1;i<=NF;i++){ if(NR==1) arr[i]=$i; else arr[i]=arr[i]$i"##|";} } END{ for(i=2;i<=NF;i++)print  arr[i];}' >>${current_app_info_file}
#        echo $line  >> ${current_app_info_file}
    done < ${current_app_list_file}    # 读取存储ip的文件
    echo "get ${current_app_list_file} status into ${current_app_info_file} Done"
}

#获取application
yarn application -list -appStates ALL | awk -F '\t' '{print $1}' >${app_list_file}
grep application ${app_list_file} >.tmp
mv .tmp ${app_list_file}
split_file ${app_list_file}
job_num=$? #任务总数


tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile      # 新建一个fifo类型的文件
exec 6<>$tmp_fifofile     # 将fd6指向fifo类型
rm $tmp_fifofile    #删也可以

thread_num=10  # 最大可同时执行线程数量

#根据线程总数量设置令牌个数
for ((i=0;i<${thread_num};i++));do
    echo
done >&6

for ((i=1;i<=${job_num};i++));do # 任务数量
    # 一个read -u6命令执行一次，就从fd6中减去一个回车符，然后向下执行，
    # fd6中没有回车符的时候，就停在这了，从而实现了线程数量控制
    read -u6

    #可以把具体的需要执行的命令封装成一个函数
    {
        get_status ${i}
    } &

    echo >&6 # 当进程结束以后，再向fd6中加上一个回车符，即补上了read -u6减去的那个
done

wait
exec 6>&- # 关闭fd6
echo "over"


cat app_info* >${app_info_file}
rm app_list*
rm app_info*
sed -i 's/ MB-seconds, /##|MB-seconds##|/' ${app_info_file}
# 将资源占用的值与单位分割开
sed -i 's/ vcore/##|vcore/' ${app_info_file}
# 注意：^M的输入方式是 Ctrl + v ，然后Ctrl + M 
#sed -i 's/^M//g' ${app_info_file}
sed -i 's/
//g' ${app_info_file}
# 将查询语句中包含的单引号前加一个反斜 杠
sed -i "s/'/\\\'/g" ${app_info_file}

