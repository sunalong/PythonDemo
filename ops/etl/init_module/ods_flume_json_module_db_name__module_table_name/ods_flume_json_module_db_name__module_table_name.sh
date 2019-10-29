#! /bin/bash

declare -r curr_dir=$(cd `dirname $0`; pwd)


properties_file="ods_flume_json_module_db_name__module_table_name.properties"
conf_file="${curr_dir}/${properties_file}"

agent_name=`cat  ${conf_file} | grep "transactionCapacity" | awk -F "." '{print $1}'`
flume-ng agent \
--conf ${FLUME_CONFIG_DIR}  \
--conf-file "${conf_file}" \
--name "${agent_name}" \
-Dflume.root.logger=INFO,console \
-Dflume.monitoring.type=http \
-Dflume.monitoring.port=60008
