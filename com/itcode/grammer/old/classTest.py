#!/usr/bin/python
#coding:utf-8
class Employee:
    '所有员工的基类'
    empCount=0
    #类的构造函数或初始化方法
    #self代表类的实例，在定义类的方法时是必须有的，虽然在调用昧必传入相应的参数
    def __init__(self,name,salary):
        self.name = name
        self.salary = salary
        Employee.empCount +=1
    #类的方法与普通只有一个特别的区别，它们必须有一个额外的第一个参数名称,一般计作 self
    def displayCount(self):
        print "Total emeployee %d" % Employee.empCount

    def displayEmployee(self):
        print "Name:",self.name,",Salary:",self.salary

    #self代表的是类的实例，代表当前对象的地址，而self.class则批向类
    #self不是python关键字，可随意替换，如换成fuck
    def prtSelf(self):
        print self
        print self.__class__

zs = Employee("zsname",20000)
zs.displayCount()
zs.displayEmployee()
zs.prtSelf()

print "\n访问属性的函数："
print hasattr(zs,"name")
print getattr(zs,"name")
print setattr(zs,"gender","man")#添加属性，无返回值，或返回值为None
print getattr(zs,"gender")
print delattr(zs,"name")
print hasattr(zs,"name")

print "\n内置类属性："
print "Employee.__name__:",Employee.__name__
print "Employee.__doc__:",Employee.__doc__
print "Employee.__module__:",Employee.__module__
print "Employee.__bases__:",Employee.__bases__
print "Employee.__dict__:",Employee.__dict__
