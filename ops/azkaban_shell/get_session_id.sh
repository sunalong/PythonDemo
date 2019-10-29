#!/usr/bin/env bash

result=`curl -k -X POST -d action=login -d username=azkaban -d password=azkaban http://work-study-05:8081`


echo "$result" | grep "session.id" | grep ":"
#echo "$result"


#curl -k -d ajax=scheduleCronFlow -d projectName=handal_test1 -d flow=foo6 --data-urlencode cronExpression="0 23/30 5,7-10 ? * 6#3" -b "azkaban.browser.session.id=c60c8162-05fa-4042-9de0-8de352e8d60c" http://work-study-05:8081/schedule