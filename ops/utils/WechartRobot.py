# -*- coding: utf-8 -*-

from com.itcode.utils.exception_alert import AlertRobot


class WechartRobot:
    # 1.大数据作业异常预警 -> 包括azkaba流程失败,sqoop日志监控， hdfs文件监控到，flume取数流程监控
    task_exception_group = "大数据作业异常预警"

    # 2.大数据数据异常预警 -> ods/dwd/dwd/rpt/等各个层级数据异常
    data_exception_group = "大数据数据异常预警"

    # 3.大数据集群资源预警 -> hdfs/presto/yarn/kafka/flink集群资源预警
    cluster_usable_group = "大数据集群资源预警"

    # 4.大数据重点项目预警 -> 日报，小票 ...
    import_project_group = "大数据重点项目预警"

    # 5.大数据实时应用预警 -> spark，clickhouse,flink 等
    realtime_apply_group = "大数据实时应用预警"

    def __init__(self):
        pass

    def alert(self, group, msg):
        # group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        AlertRobot(group).send_message(msg)
