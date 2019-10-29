try:
    num = int(input("输入一个整数："))
    result = 8/num
    print(result)
except ValueError:
    print("请输入正确的整数")
except ZeroDivisionError:
    print("除0错误")