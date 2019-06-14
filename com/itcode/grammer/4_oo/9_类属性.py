class Tool(object):
    #使用赋值语句定义类属性，记录所有工具对象的数量
    count=0
    def __init__(self,name):
        self.name = name
        #让类属性的值+1
        Tool.count+=1

# 1.创建工具对象
tool1 = Tool("斧头")
tool2 = Tool("榔头")
tool3 = Tool("水桶")
# 2.输出工具对象的总数
print("工具对象地址1：%d"%id(tool3.count))
tool3.count = 99
print("工具对象总数1: %d"%tool3.count)
print("工具对象总数2: %d"%Tool.count)
print("工具对象地址2：%d"%id(Tool.count))
