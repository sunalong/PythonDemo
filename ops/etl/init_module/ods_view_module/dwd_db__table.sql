set mapreduce.map.memory.mb=2048;
set mapreduce.map.java.opts=-Xmx2048m;
set mapreduce.reduce.memory.mb=4096;
set mapreduce.reduce.java.opts=-Xmx4096m;
set mapreduce.job.reduce.slowstart.completedmaps=0.8;
set mapred.job.name=dwd.__dwd_hive_table_name__;

INSERT OVERWRITE TABLE dwd.__dwd_hive_table_name__
select  __columns__
from (select *
      , row_number() over (distribute by  __primary_key__  sort by __order_field__  desc )  num
      from (select  __columns__
            from ods.__ods_hive_table_name__
            union all
            select  __columns__
            from ods_view.__ods_view_hive_table_name__
            where datelabel >= ${start_date}
      ) as un_tmp
) t
where t.num=1 and id is not null



