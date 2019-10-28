students =[
    {"name":"阿土"},
    {"name":"小美"}
]
# 在学员列表中搜索指定的姓名
find_name="张三"
for stu_dic in students:
    print(stu_dic)
    if stu_dic["name"] == find_name:
        print("找到了 %s"%find_name)
        # 如果已经找到，退出循环
        break
else:
    # 遍历完列表后，没有找到，需要有个指示
    print("没有找到%s"%find_name)
print("循环结束")