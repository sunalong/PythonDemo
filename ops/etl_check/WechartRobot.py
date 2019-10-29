# -*- coding: utf-8 -*-

from etl_check.exception_alert import AlertRobot


class WechartRobot:
    failture_group = "大数据作业失败预警"
    realtime_group = "大数据实时应用预警"
    importpro_group = "大数据重点项目预警"
    exception_group = "大数据作业异常预警"

    def __init__(self):
        pass

    def alert(self, group, msg):
        # group 可选择的四个群聊：大数据作业失败预警/大数据实时应用预警/大数据重点项目预警/大数据作业异常预警
        AlertRobot(group).send_message(msg)
