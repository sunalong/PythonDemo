# -*- coding: utf-8 -*-
name1 = str(input("请输入姓名："))
name2 = input("请输入姓名：")
print("name1 is %s,name2 is %s." % (name1,name2))
student_no = 123
print("学号是:%06d"%student_no) #不够的位以0补齐
print("学号是:% 6d"%student_no) #不够的位以空格补齐

scale = float(input("请输入小数:"))
print("数据比例是:%.2f%%"%(scale*100)) #数据比例是:80.00%