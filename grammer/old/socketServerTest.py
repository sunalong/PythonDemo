#!/usr/bin/python
#coding:utf-8
import socket
s = socket.socket
host = socket.gethostname()
port = 12345
s.bind((host,port))

s.listen(5)
while True:
    c,addr = s.accept()
    print("连接地址：",addr)
    c.send("欢迎访问菜鸟教程")
    c.close()