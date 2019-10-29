# 1.打开文件
file = open("README")

# 2.读取文件内容
text = file.read()
print(text)
print(len(text))
print("读取文件后 文件指针会改变")
# 读取文件后 文件指针会改变
text = file.read()
print(text)
print(len(text))
# 3.关闭文件
file.close()


# with 方式可避免没有关闭资源文件产生错误
# readliines 逐行读取
print("with 方式:-----1------")
with open('README', 'r') as config_file:
    for single_line in config_file:
        # single_line = config_file.readline()
        print("single_line:", single_line)
    print("single_line done")
print("with 方式:-----2------")
