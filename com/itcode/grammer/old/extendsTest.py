#!/usr/bin/python
# coding:utf-8

# 类的继承
# 面向对象的编程带来的主要好处之一是代码的重用，实现这种重用的方法之一是通过继承机制
# 通过继承创建的新类称为子类或派生类，被继承的类称为基类、父类或超类
# 语法：class 派生类名(基类名)

# 继承中的一些特点：
# 1.如果子类中需要父类的构造方法，就需要显示的调用父类的构造方法，或者不重写父类的构造方法
# 2.在调用基类的方法时，需要加上基类的类名前缀，且需要带上self参数变量。区别在于类中调用普通函数时并不需要带上self参数
# 3.Python总是首先查找对应类型的方法，如果它不能在派生类中找到对应的方法，它才开始到基类中逐个查找
# 4.可以多继承 class C(A,B)

# 可使用issubclass()或isinstance()方法来检测
class Parent:
    parentAttr = 100

    def __init__(self):
        print "调用父类构造函数"

    def parentMethod(self):
        print "调用父类方法"

    def setAttr(self, attr):
        Parent.parentAttr = attr

    def parGetAttr(self):
        print "父类属性：", Parent.parentAttr


class Child(Parent):
    def __init__(self):
        print "调用子类构造方法"

    def childMethod(self):
        print "调用子类方法"


c = Child()
c.childMethod()
c.parentMethod()
c.setAttr(200)
c.parGetAttr()


class Vector:
    def __init__(self, a, b):
        self.a = a
        self.b = b

    def __str__(self):
        return "Vector(%f,%d)" % (self.a, self.b)

    def __add__(self, other):
        return Vector(self.a + other.a, self.b + other.b)

v1 = Vector(2,10)
v2 = Vector(5.123456789,-2)
print v1+v2
print v2
print v2.__str__()


