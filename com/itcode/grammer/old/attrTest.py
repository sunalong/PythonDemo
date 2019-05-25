#!/usr/bin/python
#coding:utf-8
#类的私有属性
#__private_attrs:两个下划线开头，声明该属性为私有，在类内部使用时：self.__private_attrs

#类的方法
#在类的内部，使用def关键字可为类定义一个方法

#类的私有方法
#__private_method:两个下划线开头，声明该方法为私有方法，不能在类的外部调用。
#在类的内部调用self.__private_methods

class JustCounter:
    __secretCount=0 #私有变量
    publicCount = 0 #公有变量

    def count(self):
        self.__secretCount+=1
        self.publicCount +=1
        print self.__secretCount

counter = JustCounter()
counter.count()
counter.count()
print counter.publicCount
#python不允许实例化的类访问私有数据，但可使用 object.__className__privateAttrName 访问私有属性
#__foo__：定义的是特殊方法，一般是系统定义名字，类似 __init__() 之类的
#_foo:以单下划线开头的表示的是protected类型的变量，即保护类型只能允许其本身与子类进行访问，不能用于from module import *

print "通过 object.__className__attrName可访问私有属性",counter._JustCounter__secretCount