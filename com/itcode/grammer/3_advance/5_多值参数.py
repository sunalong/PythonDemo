def demo(num,*nums,**person):
    print(num)
    print(nums)
    print(person)

# demo(1)
demo(1,2,3,4,5,name="小明",age=18)

print("-"*50)

# 多值参数求和
def sum_numbers(*args):
    num = 0
    print(args)
    # 循环遍历
    for n in args:
        num+=n
    return num

result = sum_numbers(1,2,3,4,5)
print(result)