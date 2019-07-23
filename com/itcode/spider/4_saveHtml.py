# encoding:utf-8
import ssl
from http.cookiejar import CookieJar
from urllib import request, parse

headers = {
    'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
}


def get_opener():
    # 1.创建一个cookieJar对象
    cookieJar = CookieJar()
    # 2.使用cookieJar创建一个HTTPCookieProcess对象
    handler = request.HTTPCookieProcessor(cookieJar)
    # 3.使用上一步创建的handler创建一个opener
    opener = request.build_opener(handler)
    return opener


def login_renren(opener):
    # 使用opener发送登录的请求
    data = {
        'email': '466210864@qq.com',
        'password': 'gkog,vqvl.!9'

    }
    login_url = 'http://passport.csdn.net/login'
    req = request.Request(login_url, data=parse.urlencode(data).encode('utf-8'), headers=headers,method='POST')
    opener.open(req)

def visit_profile(opener):
    # 个人主页
    sunalong_url = 'https://me.csdn.net/sunalongl'
    req = request.Request(sunalong_url,headers=headers)
    resp = opener.open(req)
    with open('csdn.html','w',encoding='utf-8') as fp:
        fp.write(resp.read().decode('utf-8'))

if __name__ == '__main__':
    ssl._create_default_https_context = ssl._create_unverified_context
    opener = get_opener()
    login_renren(opener)
    visit_profile(opener)