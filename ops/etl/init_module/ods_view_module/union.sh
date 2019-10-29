#! /bin/bash -x

declare -r curr_dir=$(cd `dirname $0`; pwd)
$curr_dir/dwd_db__table.sh
