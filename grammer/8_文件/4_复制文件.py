# 1.打开
file_read = open("README")
file_write = open("README复件","w")

# 2.读写
text = file_read.read()
file_write.write(text)

# 2.2 复制大文件
# while True:
#     # 读取一行内容
#     text = file_read.readline()
#     #判断是否读取到内容
#     if not text:
#         break
#     file_write.write(text)

# 3.关闭
file_read.close()
file_write.close()