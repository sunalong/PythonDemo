class A:
    def test(self):
        print("class A test method")

class B:
    def demo(self):
        print("class B demo method")

class C(A,B):
    """多继承可以让子类对象同时具有多个父类的属性和方法"""
    pass

# 创建子类对象
c =C()
c.test()
c.demo()
print(C.__mro__)
