#!/bin/usr/python
# coding:UTF-8
def write_file():
    try:
        fh = open("testfile", "w")
        fh.write("这是一个测试文件，用于测试异常")
    except IOError:
        print "Error:没有找到文件或读取文件失败"
    finally:
        print "Finally 输出"
    # else:
    #     print "内容写入文件成功"
        fh.close()


def write_file_error():
    try:
        fh = open("testfile", "r")
        fh.write("这是一个测试文件，用于测试异常")
    except IOError:
        print "Error:没有找到文件或读取文件失败"
    finally:
        print "Finally 输出"
    # else:
    #     print "内容写入文件成功"
        fh.close()


write_file()
write_file_error()

def mye( level ):
    if level < 1:
        raise Exception("Invalid level!",level)

try:
    mye(0)
except Exception,err:
    print 1,err
else:
    print 2


class Networkerror(RuntimeError):
    def __init__(self,arg):
        self.args = arg

try:
    raise Networkerror("bad hostname")
except Networkerror,e:
    print e.args