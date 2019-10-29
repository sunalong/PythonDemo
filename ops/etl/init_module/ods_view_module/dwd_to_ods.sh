#! /bin/bash -x

currentDate=`date +%Y%m%d -d ' -2 day'`
currentTime=`date +%H:%M:%S`
columns="__columns__"
hive -e "
INSERT OVERWRITE TABLE ods.__ods_hive_table_name__
select  ${columns}
from dwd.__dwd_hive_table_name__"


