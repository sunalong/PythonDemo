用途：
    获取ganglia 的metrics 数据
    判断数据，查看资源使用情况超过75%，并预警


集群资源使用情况详细说明：
一：获取ganglia 的metrics 数据
    1.获取数据、解析，插入mysql
        代码路径：com/itcode/ops/cluster/parse_json.py
        获取ganglia 的metrics json数据
        解析 json 数据，添加到list中
        将list中的数据放到插入语句中，批次插入到mysql 190 中
        表：data_governance.ganglia_cluster

    2.mysql 190信息：
        host=10.10.49.190
        port=3306
        user=dev_user
        passwd=Ygvb456#


二：判断mysql的结果,根据结果来报警或提示
    1.判断使用情况并报警
        代码路径：com/itcode/ops/cluster/clusterHelper.py
        group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        按序号 将各表ETL情况发送到 大数据集群资源预警 中
        由于报警频繁，改为每小时检查一次

    2.报警示例：
        集群：presto_cluster_analyst
        内存使用：421 GB
        整体内存：503 GB
        占比：83.79%
        时间：2019-07-17 22:00:02

三：其他说明：
    已配置为自动化，人工不必干涉


