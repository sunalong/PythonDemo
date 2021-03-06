# -*- coding: utf-8 -*-


import math
# 读取总txt文件
# open_diff = open('./src_data.txt', 'r')
# open_diff = open('./000000_0', 'r')
#open_diff = open('./hdfs_data/000001_0', 'r')
import os

import shutil

import sys

for i in range(0, len(sys.argv)):
    print(str(i) + ": " + sys.argv[i])
conf_path = os.path.dirname(os.path.abspath(sys.argv[0]))
print("conf_path:" + conf_path)

open_file_path=conf_path+'/hdfs_data/dest_file'
open_diff = open(open_file_path, 'r')
# print("open_diff:" + open_diff)
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

project_dir=conf_path + "/seg_file_to_insert"
if os.path.exists(project_dir):
    print("目录：" + project_dir + "   已经存在,删除重建")
    shutil.rmtree(project_dir)
os.makedirs(project_dir)
print("目录：" + project_dir + "   创建成功")


# 将切分的写入多个txt中
for i, j in zip(range(0, count), range(0, count)):
    with open(project_dir+'/seg_file_to_insert_%d.sql' % j, 'w+') as temp:
        temp.write("insert into dim.dim_category_goods_sensors values \n")
        # print("i=%d,j=%d,lens=%d",(i, j,len(diff_match_split[i])))
        index=0
        for eachline in diff_match_split[i]:
            index+=1
            fieldsArr = eachline.strip().split('\t')
            dim_goods_id = fieldsArr[0]
            lens = fieldsArr.__len__()
            # print("lens:",lens,'   dim_goods_id:',dim_goods_id)
            records = ''.join(("( '"
                               , fieldsArr[0],  "', '"
                               , fieldsArr[1],  "', '"
                               , fieldsArr[2],  "', '"
                               , fieldsArr[3],  "', '"
                               , fieldsArr[4],  "', '"
                               , fieldsArr[5],  "', '"
                               , fieldsArr[6],  "', '"
                               , fieldsArr[7],  "', '"
                               , fieldsArr[8],  "', '"
                               , fieldsArr[9],  "', '"
                               , fieldsArr[10], "', '"
                               , fieldsArr[11], "', '"
                               , fieldsArr[12], "', '"
                               , fieldsArr[13], "', '"
                               , fieldsArr[14], "', '"
                               , fieldsArr[15], "', '"
                               , fieldsArr[16], "', '"
                               , fieldsArr[17], "', '"
                               , fieldsArr[18], "') "))
            if index == len(diff_match_split[i]):
                line = ''.join((records, ';\n'))
                # print("到达最后一个！:",line)
            else:
                line = ''.join((records, ',\n'))
            temp.write(line)



