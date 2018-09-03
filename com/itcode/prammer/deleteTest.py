#!/usr/bin/python
#coding:utf-8


#pyton使用了引用计数这一简单技术来跟踪和回收垃圾
#在python内部记录着所有使用中的对象各有多少引用
#一个内部跟踪变量，称为一个引用计数器
#当对象被创建时，就创建了一个引用计数，当这个对象不再需要时，即这个对象的引用计数为0时，被垃圾回收，
#但回收不是立即的，由解释器在适当的时机，将垃圾对象占用的内存空间回收
#垃圾回收机制不仅针对引用计数为0的对象，同样也可处理循环引用的情况，循环引用指的是，两个对象相互引用，但没其他亦是引用它们
#这种情况下，仅使用引用计数是不够的。
#Python的垃圾收集吕实际上是一个引用计数器和一个循环垃圾收集器。
#作为引用计数的补充，垃圾收集器也会留心被分配的总量很大（及未通过引用计数销毁的那些）的对象。
#这种情况下，解释器会暂停下来，试图清理所有未引用的循环
a=40
b=a
c=[b]
del a
b=100
c[0]=-1

class Point:
    def __init__(self,x=0,y=0):
        print self.__class__.__name__,"构造函数被调用"
        self.x = x
        self.y = y
    def __del__(self):
        class_name = self.__class__.__name__
        print class_name,"被销毁"

pt1 = Point()
pt2 =pt1
pt3 = pt1
print id(pt1),id(pt2),id(pt3)#打印对象的id
print "删除pt1："
del pt1
print "删除pt2："
del pt2
print "删除pt3："
del pt3
