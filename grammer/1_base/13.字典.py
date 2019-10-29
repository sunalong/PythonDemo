# 字典是一个无序的数据集合，
# 存储描述一个物体的相关信息，描述更复杂的灵气信息
# 类似javaBean

# 使用print函数输出字典时，通常输出的顺序和定义的顺序是不一致的
xiaoming_dict = {"name": "小明",
            "gender": True,
            "height": 1.75,
            "weight": 75.5}
print(xiaoming_dict)


# 1.取值 如果指定的key不存在，会报错
print(xiaoming_dict['name'])
# # KeyError: 'name1'
# print(xiaoming_dict['name1'])

# 2.增加/修改
# 如果key不存在，会新增键值对
xiaoming_dict['age']=18
# 如果key存在，会修改已存在的键值对
xiaoming_dict['name']='小小明'
print(xiaoming_dict)

# 3.删除
xiaoming_dict.pop("name")
# 在删除指定键值对的时候，如果指定的key不存在，程序会报错
# xiaoming_dict.pop('name1')
print(xiaoming_dict)

# 4.统计键值对
print(len(xiaoming_dict))

# 5.合并字典
temp_dict={"aa":1,'bb':2}
xiaoming_dict.update(temp_dict)
print(xiaoming_dict)

# 6.清空字典
# xiaoming_dict.clear()
# print(xiaoming_dict)

# 7.遍历
# 变量key是每一美人鱼循环中，获取到的键值对的key
for key in xiaoming_dict:
    print("%s -- %s"%(key,xiaoming_dict[key]))