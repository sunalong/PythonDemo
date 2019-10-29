#! /bin/bash -x

# 生成 要删除指定目录的数据文件
#hdfs dfs -du -h /user/sqoop/ods >./dir_to_be_clear.txt
rm ./result.txt
while read line;do
        #dir_to_be_clear=`echo $line | cut -d "\t" -f3`      # 提取文件中的目录
        dir_to_be_clear=`echo $line | awk 'BEGIN{FS=" "} {print $5}' `      # 提取文件中的目录
        if [[ "${dir_to_be_clear}" == "" ]];then
            echo "dir_to_be_clear is blankspace,continue"
        else
            # 删除 2018年全年、2019年1-3月的数据
            echo "hdfs dfs -rm -r ${dir_to_be_clear}/datelabel=2018*">>./result.txt
            echo "hdfs dfs -rm -r ${dir_to_be_clear}/datelabel=201901*">>./result.txt
            echo "hdfs dfs -rm -r ${dir_to_be_clear}/datelabel=201902*">>./result.txt
            echo "hdfs dfs -rm -r ${dir_to_be_clear}/datelabel=201903*">>./result.txt
        fi

        #dir_to_be_clear=`echo $line | awk 'BEGIN{OFS="-";FS=" "} {print $5}' `      # 提取文件中的目录

done < ./dir_to_be_clear.txt      # 读取存储要清除数据的目录文件