i = 1
while i <= 3:
    print(str(i) + ":hello pytohn")
    i += 1
print("循环结束后，i=", i)



print("break:", "-" * 50)
i = 0
while i < 10:
    if i == 3:
        break
    print("i=", i)
    i += 1
print("循环结束后，i=", i)



print("continue:", "-" * 50)
i = 0
while i < 5:
    if i == 3:
        i += 1
        continue
    print(i)
    i += 1
print("循环结束后，i=", i)
