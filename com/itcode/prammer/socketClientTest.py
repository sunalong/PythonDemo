#!/usr/bin/python
#coding:utf-8

import socket
s = socket.socket()
host = socket.gethostname()
port = 12345
s.connect((host,port))
print "客户端接收到的数据：",s.recv(1024)
s.close()