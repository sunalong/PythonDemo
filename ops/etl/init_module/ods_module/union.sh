#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
$curr_dir/mysql2HiveTmp.sh
$curr_dir/overwritehive.sh
