# -*- coding: utf-8 -*-
# name1 = str(input("请输入姓名："))
# name2 = input("请输入姓名：")
# print("name1 is %s,name2 is %s." % (name1,name2))
student_no = 123
print("学号是:%06d"%student_no) #不够的位以0补齐
print("学号是:% 6d"%student_no) #不够的位以空格补齐

# scale = float(input("请输入小数:"))
# print("数据比例是:%.2f%%"%(scale*100)) #数据比例是:80.00%

x=7
# int(x [,base]) # 将x转换为一个整数
print("chr(x) :",chr(x)) # 将一个整数转换为一个字符
print("int(x):",type(int(x))) # 将x转换为一个整数
# complex(real [,imag]) # 创建一个复数
print("float(x ) :",float(x )) # 将x转换到一个浮点数
print("str(x) :",str(x)) # 将对象x转换为字符串
print("repr(x) :",repr(x)) # 将对象x转换为表达式字符串
# print("unichr(x) :",unichr(x)) # 将一个整数转换为Unicode字符
# print("unichr(x) :",unichr(x)) # 将一个整数转换为Unicode字符

print("ord(x) :",ord('a')) # 将一个字符转换为它的整数值
print("hex(x) :",hex(9)) # 将一个整数转换为一个十六进制字符串
print("oct(x) :",oct(9)) # 将一个整数转换为一个八进制字符串
str="5*2+3"
print("eval(\"5*2+3\"):",eval(str)) # 用来计算在字符串中的有效Python表达式,并返回一个对象
s="12345"
print(tuple(s)) # 将序列s转换为一个元组
print(list(s)) # 将序列s转换为一个列表


# unicode 编码
print("-"*50)
# print("lala".encode().decode('\u9500\u552e'))
print("\"lala\".encode():","销售".encode()) # b'\xe9\x94\x80\xe5\x94\xae'
# print("decode:",'\u9500\u552e'.decode('unicode_escape'))
import json
s = '\\u9500\\u552e'
print("fuck:",json.loads(f'"{s}"')) #fuck: 销售
