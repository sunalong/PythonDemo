name_list=["张三",'张四','张五']
# 使用 del 关键字删除列表元素
# 日常开发中，要从列表删除数据，建议使用列表提供的方法
del name_list[1]
print(name_list)

# del 关键字本质上是用来将一个变量从内存中删除
name ='小明'
del name
# 注意：如果使用del关键字将变量从内存中删除，后续的代码就不能再使用这个变量了
# NameError: name 'name' is not defined
# print(name)
print(name_list)
