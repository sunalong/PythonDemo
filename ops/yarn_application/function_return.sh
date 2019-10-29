
#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)


function split_file(){
    file_num=2019-08-07
#    return $file_num
    echo $file_num
}

echo "函数的返回值："$(split_file)

