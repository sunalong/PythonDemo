try:
    num = int(input("输入一个整数："))
    result = 8 / num
    print(result)
except ValueError as errorStr:
    print("请输入正确的整数,错误类型：%s"%errorStr)
except Exception as result:
    print("未知错误:%s" % result)
