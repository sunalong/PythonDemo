# -*- coding: utf-8 -*-
# 修复神策文件分隔符导致的异常

with open('rawall.txt', 'r') as f:
    str=f.read()


index=1
line_str=''
strarr = str.split('|')
resultList=[]
for s in strarr:
    if index%9==0:
        sub_arr=s.split(",")
        if sub_arr.__len__()==2:
            line_str+=sub_arr[0]+"|"+sub_arr[1]+"|"
            index+=1
        else:
            line_str+=s+"|"
    else:
        line_str+=s+"|"
    index+=1

# print(line_str)

line_str2=''
index2=1
strarr = line_str.split('|')
for s in strarr:
    if index2 % 9 == 0:
        line_str2+=s
        resultList.append(line_str2)
        line_str2=""
    else:
        line_str2 += s + "|"
    index2 += 1


print("---"*20)
with open('fuckme.txt', 'w') as f:
    for item in resultList:
        print(item)
        f.write(item)
        f.write("\n")

