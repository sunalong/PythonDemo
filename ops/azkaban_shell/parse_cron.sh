#!/usr/bin/env bash


flow_info=`cat ./flow_info.properties`

flow_name=`echo "${flow_info}" | grep "^flow_name" | awk -F '=' '{print $2}'`
cron_expr=`echo "${flow_info}" | grep "^cron_expr" | awk -F '=' '{print $2}'`
echo "${flow_name}"
echo "${cron_expr}"


function get_name(){

 echo ""
}




