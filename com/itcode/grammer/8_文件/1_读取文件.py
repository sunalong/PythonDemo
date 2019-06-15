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

