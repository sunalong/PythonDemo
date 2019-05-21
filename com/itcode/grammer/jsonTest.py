#!/usr/bin/python
#coding:utf-8
import json
data = [{'a':1,'b':2,'c':3,'d':4,'e':5}]
jsonObj = json.dumps(data)
print "正常输出josn:",jsonObj
print "格式化输出json:\n",json.dumps(data,sort_keys=True,indent=4,separators=(',',': '))
print "格式化输出json:\n",json.dumps({'a':'Runoob','b':7},sort_keys=True,indent=4,separators=(',',': '))
