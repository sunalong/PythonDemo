use ods;
CREATE EXTERNAL TABLE `ods_flume_json_module_db_name__module_table_name`(
`json_str` string
)
PARTITIONED BY ( 
  `datelabel` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\u0005' 
  LINES TERMINATED BY '\n' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://Ucluster/user/sqoop/ods/ods_flume_json_module_db_name__module_table_name';
