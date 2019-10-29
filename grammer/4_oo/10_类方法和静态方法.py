class Tool(object):
    # 使用赋值语句定义类属性，记录所有工具对象的数量
    count =0
    @classmethod
    def show_tool_count(cls):
        print("类方法：工具对象的数量 %d"%cls.count)

    @staticmethod
    def work():
        #不访问实例属性、类属性
        print("静态方法：Tools work...")
        
    def __init__(self,name):
        self.name = name
        # 让类属性的值+1
        Tool.count+=1

#创建工具对象
tool1 = Tool("斧头")
tool2 = Tool("榔头")
#调用类方法
Tool.show_tool_count()

#通过类名. 调用静态方法 - 不需要创建对象
Tool.work()