name_list=['张一','张二','张三','张四','张三']
# 1.len 可以统计列表中元素的总数
list_len = len(name_list)
print("列表中包含 %d 个元素"%list_len)

# 2.count 方法可以统计列表中某一个数据出现的次数
count=name_list.count('张三')
print("张三出现了 %d 次"%count)

# 3.从列表中删除第一次出现的数据，如果数据不存在，程序会报错
name_list.remove("张7")
# ValueError: list.remove(x): x not in list
print(name_list)