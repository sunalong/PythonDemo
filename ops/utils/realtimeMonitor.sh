#!/bin/bash 

source /data/user/wangyf/py3_email/email/bin/activate

cd /data/sqoop/monitor_tool

python /data/sqoop/monitor_tool/realtimeReportMonitor.py --msg '大屏指标数据平台接口(蒲仁松、王义飞)' --url 'http://yc-bi-api.yonghuivip.com/portal-api/openApi/portal/report?openApiCode=OPENAPI_000266&shopId=9L09&sign=d994dad5c06be7e99708be3d52c913d8'

deactivate
