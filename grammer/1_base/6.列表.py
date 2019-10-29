name_list = ["zs1","zs2",'zs3','zs4']

# 1.聚会和取索引
print(name_list[2])

# 根据值求索引，如果值不在列表中，会报错
print(name_list.index('zs2'))

# #ValueError: 'zs5' is not in list
# print(name_list.index('zs5'))

# 2.修改
name_list[1]='张三'
print(name_list)
# IndexError: list assignment index out of range
# name_list[7]='张三'

# 3.增加
# append 方法向列表的末尾追回数据
name_list.append("李四Append")
print(name_list)
# insert 方法在列表的指定索引位置插入数据
name_list.insert(1,'美女')
print(name_list)
# extend 方法要以把其他列表中的完整内容，追加到当前列表的末尾
temp_list=['孙悟空','妖怪打妖怪']
name_list.extend(temp_list)
print(name_list)

# 4.删除
# remove 方法可以从列表中删除指定的数据
name_list.remove("美女")
print(name_list)
# pop 方法默认可把列表中最后一个元素删除
name_list.pop()
print(name_list)
# clear 方法可以清空列表
name_list.clear()
print(name_list)
