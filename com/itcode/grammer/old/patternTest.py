#!/usr/bin/python
#coding:utf-8
#Python自1.5版本起增加了re模块，它提供了Perl风格的正则表达式模式
#re模块使python语言拥有全部的正则表达式功能
#compile函数根据一个模式字符口中 和可选的标志参数生成一个正则表达式对象。
#该对象拥有一系列方法用于正则表达式匹配和替换
#re模块也提供了与这些方法功能完全一致的函数，这些函数使用一个模式字符串做为它们的第一个参数

#re.match函数：
#尝试从字符串的起始位置切尔西一个模式，如果不是起始位置匹配成功的话，返回none
#如果匹配成功，re.match返回一个匹配的对象。
#可使用group(num)或groups()匹配对象函数来获取匹配表达式

#当匹配成功时,返回一个match对象：
#group([group1,...])：用于获得一个或多个分组匹配的字符串，当要获得整个匹配的子串时，可直接使用group()或group(0)
#start([group])：用于获取分组匹配的子串在整个字符串中的起始位置(子串第一个字符的索引)，参数默认值为0
#end([group])：用于获取分组匹配的子串在整个字符串中的结束位置(子串最后一个字符的索引+1),参数默认值为0
#span([group])：返回(start(group),end(group))
import re
print "在起始位置匹配：",re.match("www","www.github.com")
print "不在起始位置匹配：",re.match("git","www.github.com")
print re.match("www","www.github.com").span()
print re.match("www","www.github.com").group()



def printReResult(matchObj):
    if matchObj:
        print "matchObj.group():",matchObj.group()
        print "matchObj.group(1):",matchObj.group(1)
        print "matchObj.group(2):",matchObj.group(2)
    else:
        print "No match!"

#re.search方法：扫描整个字符串并返回第一个成功的匹配
#匹配成功返回一个匹配的对象，否则返回None

print "\n在起始位置扫描：",re.search("www",'www.github.com').span()
print "不在起始位置扫描：",re.search("git",'www.github.com').span()


line = "Cats are smarter than dogs"
matchObj = re.match(r'(.*) are (.*?) .*',line,re.M|re.I)
searchObj = re.search(r'(.*) are (.*?) .*',line,re.M|re.I)
print "\nmatch结果："
printReResult(matchObj)

print "search结果："
printReResult(searchObj)

#re.match与re.search的区别：
#re.match只匹配字符串的开始，如果字符串开始不符合正则表达式，则匹配失败，返回None;
#re.search匹配整个字符串，走到找到一个匹配

#检索和替换
#Python的re模块提供了re.sub用于替换字符串中的匹配项
#语法：re.sub(pattern, repl, string, count=0, flags=0)
#   pattern：正则中的模式字符串
#   repl：替换的字符串，也可为一个函数
#   string：要被查找替换的原始字符串
#   count：模式匹配后替换的最大次数，默认0表示替换所有的匹配
phone = "2004-959-559 #这是一个老外的电话号码"
#删除字符串中的 python注释
num = re.sub(r'#.*$',"",phone)
print "\n使用sub后的电话号码为：",num
#删除非数字的字符串
num = re.sub(r'\D',"",phone)# \D  匹配任意非数字
print "删除非数字后的电话号码：",num

#repl参数是函数的情形：
def double(matched):
    print "double中的match:",matched.group('fuck')
    value = int(matched.group('fuck'))
    return str(value*2)
s = 'A23G4HFD567'
print "\nrepl参数为函数的示例：",re.sub('(?P<fuck>\d+)',double,s)
print "repl参数为函数的示例：",re.sub('(?P<value>\d+)',"-",s)
#\d：匹配任意数字，等价于 [0-9].

#re.compile函数
#compile函数用于编译正则表达式，生成一个正则表达式(Pattern)对象，供match()和search()这两个函数使用
pattern = re.compile(r'\d+')#用于匹配至少一个数字
print "\n从头部查找，没有匹配:",pattern.match('one12twothree34four')
print "从e的位置开始匹配，没有匹配:",pattern.match('one12twothree34four',2,10)
m = pattern.match('one12twothree34four',3,10)
print "从1的位置开始匹配，返回一个Match对象:",m
print "m.group(0):",m.group(0)
print "m.end(0):",m.end(0)
print "m.span(0):",m.span(0)

#findall
#在字符串中找到正则表达式所匹配的所有子串，并返回一个列表，如果没有找到匹配的，则返回空列表
#match和search是匹配一次，而findall匹配所有
#语法：findall(string[, pos[, endpos]])
# string：待匹配的字符串
# pos：可选参数，指定字符串的起始位置，默认为0
# endpos：可选参数，指定字符串的结束位置，默认为字符串的长度
pattern = re.compile(r'\d+') #查找数字
result1 = pattern.findall('github 123 google 456')
result2 = pattern.findall("run88oob123google456",0,10)
print "\nfindall:",result1
print "findall:",result2,"\n"

#re.finditer
#与findall类似，在字符串中找到正则表达式匹配的所有子串，并把它们作为一个迭代器返回：
it=re.finditer(r"\d+","12a32bc43jf3")
for match in it:
    print "finditer:",match.group()

#re.split
#split方法按照能够匹配的子串将字符串分割后返回列表，它的使用形式如下：
#re.split(pattern, string[, maxsplit=0, flags=0])
#\W：匹配非字母数字及下划线
print "re.split('\W+',  :",re.split('\W+','runoob,runoob,runoob.')
print "re.split('(\W+)',  :",re.split('(\W+)','runoob,runoob,runoob.')
print "re.split('\W+',  :",re.split('\W+','runoob,runoob,runoob.',1)
print "re.split('a*',  :",re.split('a*','hello world')
