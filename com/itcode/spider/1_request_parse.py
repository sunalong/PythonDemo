# encoding:utf-8
from urllib import request
from urllib import parse
import ssl


ssl._create_default_https_context = ssl._create_unverified_context

# 1.urlretrieve 函数的用法 下载图片
src_url = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511283869079&di=da3892a20ff8b4d535152e303f0c9ae6&imgtype=0&src=http%3A%2F%2Fi2.17173cdn.com%2F2fhnvk%2FYWxqaGBf%2Fcms3%2FESweDEbleCrnwrx.jpg'
request.urlretrieve(src_url, 'luban.jpg')

# 2.urlencode 与parse_qs 函数的用法
parmas = {'name': '张三', 'age': 18, 'greet': 'hello world'}
result = parse.urlencode(parmas)
querys = parse.parse_qs(result)
print("2.parse.urlencode+" + str(result))  # name=%E5%BC%A0%E4%B8%89&age=18&greet=hello+world
print("2.parse.parse_qs:" + str(querys) + "\n")  # {'name': ['张三'], 'age': ['18'], 'greet': ['hello world']}

# 3.urlparse 和 urlsplit 差别在于params
urlparse = parse.urlparse(src_url)
urlsplit = parse.urlsplit(src_url)
print("3.urlparse：" + str(urlparse))
print("3.urlsplit：" + str(urlsplit) + "\n")



# url = 'https://www.lagou.com/jobs/positionAjax.json?city=%E6%B7%B1%E5%9C%B3&needAddtionalResult=false&isSchoolJob=0'
url = 'https://www.lagou.com/jobs/positionAjax.json?needAddtionalResult=false'
headers = {
    'Referer': 'https://www.lagou.com/jobs/list_python?labelWords=&fromSearch=true&suginput=',
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7',
    'Connection': 'keep-alive',
    'Content-Length': '25',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Host': 'www.lagou.com',
    'Origin': 'https://www.lagou.com',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36',
    'X-Anit-Forge-Code': '0',
    'X-Anit-Forge-Token': 'None',
    'X-Requested-With': 'XMLHttpRequest',
}
data = {
    'first': 'true',
    'pn': 1,
    'kd': 'python'
}

req = request.Request(url, headers=headers, data=parse.urlencode(data).encode('utf-8'), method='POST')
resp = request.urlopen(req)
print('4.resp.read().decode(utf-8):' + resp.read().decode('utf-8')+'\n')

