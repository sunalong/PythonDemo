drop table if exists ganglia_cluster;
CREATE TABLE ganglia_cluster (
  `group` varchar(100)
, grid varchar(100)
, cluster varchar(100)
, host varchar(100)
, metric varchar(100)
, `value` varchar(100)
, units varchar(100)
, id varchar(100)
, sampleTime varchar(50)
, insert_time varchar(20)
)comment 'ganglia 监控集群各节点的日志'
;

