# -*- coding: utf-8 -*-

import datetime

from com.itcode.ops.cluster.clusterHelper import ClusterHelper
from com.itcode.ops.cluster.parse_json import Parse_json


class MonitorCluster:

    def __init__(self):
        self.curr_date=datetime.datetime.now().strftime('%Y-%m-%d')

if __name__ == '__main__':
    Parse_json().collect_insert()
    ClusterHelper().judge()
