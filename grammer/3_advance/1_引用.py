def test(num):
    print("在函数内部 %d 对应的内存地址是 %d"%(num,id(num)))
    result="hello"
    print("函数要返回数据的内存地址是 %d"%id(result))
    return result

a=10
print("a 变量保存数据的内存地址是 %d"%id(a))
# 调用test函数，本质上传递的是实参保存数据的引用，
# 而不是实参保存的数据
r=test(a)
print("%s 的内存地址是 %d"%(r,id(r)))

