class Animal:
    def eat(self):
        print("eat --")

    def drink(self):
        print("drink --")

    def run(self):
        print("run --")

    def sleep(self):
        print("sleep --")


class Dog(Animal):
    def bark(self):
        print("bark --")


class XiaoTianQuan(Dog):
    def fly(self):
        print("fly --")

    # 如果子类中，重写了父类的方法
    # 在使用子类对象调用方法时，会调用子类中重写的方法
    def bark(self):
        print("xtq bark --")
        super().bark()
        Dog.bark(self)
        print("lala")


# 创建对象
xtq = XiaoTianQuan()
xtq.fly()
xtq.bark()
