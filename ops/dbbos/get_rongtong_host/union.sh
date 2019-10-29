#!/usr/bin/env bash

declare -r curr_dir=$(cd `dirname $0`; pwd)
#$curr_dir/mysql2HiveTmp.sh

cd $curr_dir
/bin/bash $curr_dir/main.sh
/bin/bash $curr_dir/sync_to_task.sh
