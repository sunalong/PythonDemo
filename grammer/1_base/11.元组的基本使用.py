info_tuple = ("zs", 18, 1.75, 'zs')
# 1.取值和取索引
print(info_tuple[0])
print(info_tuple.index("zs"))

# 2.统计计数
print(info_tuple.count("zs"))
# 统计元组中包含元素的个数
print(len(info_tuple))

for info in info_tuple:
    # 使用格式字符串拼接info这个变量不方便！
    # 因为元组中通常保存的数据类型是不同的
    print("info is %" % info)
