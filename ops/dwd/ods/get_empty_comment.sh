#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
dwd_table_all="${curr_dir}/fuckme.txt"
dwd_table_empty="${curr_dir}/comment_empty_dwd_table"





#done
rm ${dwd_table_empty}
while read line;do
    echo $line &>>${dwd_table_empty}
    presto-client-task13 --execute "desc dwd.${line}"  |awk -F ',' '{print $1":"$4}'|sort |sed 's#"##g' &>>${dwd_table_empty}
    echo -e '\n\n' &>>${dwd_table_empty}

done<${dwd_table_all}





##done
#rm ${dwd_table_empty}
#while read line;do
#    echo line:$line
#    sql_str="presto-client-task13 --execute 'desc dwd.${line}' "
#    comment_str=`sql_str  |awk -F ',' '{print $4}'|sort |sed -n '1p'`
#
#    echo comment_str:${comment_str}
#    if [ ${comment_str}=='""' ];then
#        echo ${line} has empty comment &>>${dwd_table_empty}
#    else
#        echo ${line} donnot have empty comment
#    fi
#
#done<${dwd_table_all}


