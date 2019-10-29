#! /bin/bash -x

hive -e "use ods; 
INSERT OVERWRITE TABLE dwd.__dwd_hive_table_name__
select  __columns__
from (select *,
             row_number() over (distribute by  __primary_key__  sort by __order_field__  desc )  num 
      from ods.__ods_hive_table_name__) t 
where t.num=1; "

