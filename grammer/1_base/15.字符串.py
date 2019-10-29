str1="hello python"
str2='中文字符的遍历'
print(str1[6])
for ch in str2:
    print(ch)

# 1.统计字符串长度
print(len(str1))
print(len(str2))

# 2.统计某一子字符串出现的次数
print(str1.count("llo"))
print(str1.count("fuckme"))

# 3.查找子字符串出现的位置
print(str1.index('llo'))
# 如果给定的子字符串不存在，程序会报错
# # ValueError: substring not found
# print(str1.index('fuck'))

# 4.判断字白字符
space_str=" \t\n\r"
print("4.判断字白字符:",space_str.isspace())

# 5.判断字符串是是否只包含数字
def is_num(num_str):
    print(num_str,"isdecimal:",num_str.isdecimal())
    print(num_str,"isdigit:",num_str.isdigit())
    print(num_str,"isnumeric:",num_str.isnumeric())
is_num('1.1')
is_num('\u00b2')
is_num("一千零一")
