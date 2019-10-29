class Dog(object):
    def __init__(self, name):
        self.name = name

    def game(self):
        print("%s Dog game..." % self.name)


class XiaoTianDog(Dog):
    def game(self):
        print("%s xtd game..." % self.name)

class Person(object):
    def __init__(self,name):
        self.name = name

    def game_with_dog(self,dog):
        print("%s and %s game..."%(self.name,dog.name))
        dog.game()


# 1.创建一个狗对象
wangcai = XiaoTianDog("fly wc")

xiaoming = Person("小明")

xiaoming.game_with_dog(wangcai)