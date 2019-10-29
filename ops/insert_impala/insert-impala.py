# -*- coding: utf-8 -*-


import math
# 读取总txt文件
# open_diff = open('./src_data.txt', 'r')
# open_diff = open('./000000_0', 'r')
#open_diff = open('./hdfs_data/000001_0', 'r')
open_diff = open('./hdfs_data/dest_file', 'r')
diff_line = open_diff.readlines()

line_list = []
for line in diff_line:
    line_list.append(line)
# print(line_list)

# 分片大小
seg=100000
#seg=50
# 切分diff
diff_match_split = [line_list[i:i + seg] for i in range(0, len(line_list), seg)]

# 切分成的文件数量
count=int(math.ceil(float(len(line_list))/seg))
# print("count:",count)

# 将切分的写入多个txt中
for i, j in zip(range(0, count), range(0, count)):
    with open('./seg_file_to_insert/seg_file_to_insert_%d.sql' % j, 'w+') as temp:
        temp.write("insert into dm.dm_yh_member_wide_table values \n")
        # print("i=%d,j=%d,lens=%d",(i, j,len(diff_match_split[i])))
        index=0
        for eachline in diff_match_split[i]:
            index+=1
            fieldsArr = eachline.strip().split('\t')
            dim_member_id = fieldsArr[0]
            lens = fieldsArr.__len__()
            # print("lens:",lens)
            records = ''.join(("( '", fieldsArr[0], "', '", fieldsArr[lens - 1], "',"
                               , fieldsArr[1], ", "
                               , fieldsArr[2], ", '"
                               , fieldsArr[3], "', '"
                               , fieldsArr[4], "', "
                               , fieldsArr[5], ", '"
                               , fieldsArr[6], "', '"
                               , fieldsArr[7], "', '"
                               , fieldsArr[8], "', '"
                               , fieldsArr[9], "', '"
                               , fieldsArr[10], "', '"
                               , fieldsArr[11], "', '"
                               , fieldsArr[12], "', '"
                               , fieldsArr[13], "', '"
                               , fieldsArr[14], "', '"
                               , fieldsArr[15], "', '"
                               , fieldsArr[17], "', '"
                               , fieldsArr[18], "', '"
                               , fieldsArr[19], "', '"
                               , fieldsArr[20], "', '"
                               , fieldsArr[21], "', '"
                               , fieldsArr[22], "', '"
                               , fieldsArr[23], "', '"
                               , fieldsArr[24], "', '"
                               , fieldsArr[25], "', '"
                               , fieldsArr[26], "', '"
                               , fieldsArr[27], "') "))
            if index == len(diff_match_split[i]):
                line = ''.join((records, ';\n'))
                # print("到达最后一个！:",line)
            else:
                line = ''.join((records, ',\n'))
            temp.write(line)



