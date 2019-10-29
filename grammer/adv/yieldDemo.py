def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print("g:",g)
print("next(g):",next(g))
print("*"*20)
print("2next(g):",next(g))
# 原文链接：https://blog.csdn.net/mieleizhi0522/article/details/82142856