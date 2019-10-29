#!/usr/bin/env bash

aa="a.txt"
curl -k -i -H "Content-Type: multipart/mixed" -X POST \
--form "session.id=a00b0517-5161-47e5-bba0-e56436939d81" \
--form 'ajax=upload' \
--form 'file=@/tmp/local_git_jenkins/azkaban_flow/azkaban_flow_20180515_175601.zip' \
--form 'project=xxxxxx' \
http://work-study-05:8081/manager > $aa

echo "$?"