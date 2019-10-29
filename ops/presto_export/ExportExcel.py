# encoding: utf-8
"""
@version: v1.0
@author: sunalong
@license: Apache Licence
@contact: 466210864@qq.com
@site:
@software: PyCharm
@file: ExportExcel.py
@time: 2019/09/20 16:00
"""
import json
import sys

import os
import xlsxwriter
import prestodb
import math

def ExportExcel():
    print(str(0) + ": " + sys.argv[0])
    print(str(1) + ": " + sys.argv[1])
    # 文件名
    sql_dir = sys.argv[1]+".sql"
    (filepath, fullfilename) = os.path.split(sql_dir)
    (filename, extension) = os.path.splitext(fullfilename)

    print("filepath:",filepath)
    print("fullfilename:",fullfilename)
    print("filename:",filename)
    print("extension:",extension)
    # Excel 名称
    excel_name = filepath+"/../excel/"+filename +".xlsx"
    # Excel sheet名称
    worksheet_name = "sheet1"
    # sql文件的路径
    # 打开excel配置项
    with open(sql_dir, 'r', encoding='utf8') as f:
        sql_item = f.read()
    print(sql_item)
    conn = prestodb.dbapi.connect(host='ycbi-db-01', port=8989, user='sqoop', catalog='hive', schema='ods')
    cur = conn.cursor()
    cur.execute(sql_item)
    # 返回结果集存放到元组中
    rows = cur.fetchall()


    # 定义表头信息，返回表头信息
    table_head_all = []
    for col in cur.description:
        print("col[0]:",col[0])
        table_head_all.append(col[0])
    print("table_head_all:",table_head_all)


    # 解析json文件，获取子字段集合：中文描述及英文名称
    jsonPath=sys.argv[1]+".json"
    f=open(jsonPath,encoding='utf-8')
    jsonContent=f.read()
    json_dict=json.loads(jsonContent)
    cellTitleNames=json_dict['cellTitleNames']
    table_head_zh = []
    table_head_en = []
    for item in cellTitleNames:
        table_head_zh.append(item.split("=")[1])
        table_head_en.append(item.split("=")[0])

    # 获取子字段集合在结果集中的index
    sub_head_index=[]
    for en_item in table_head_en:
        try:
            en_itemIndex = table_head_all.index(en_item)
            sub_head_index.append(en_itemIndex)
        except Exception as result:
            print("错误：%s"%result)
            en_itemIndex = -1
            sub_head_index.append(en_itemIndex)
        # finally:
    print("sub_head_index:",sub_head_index)

    print(type(cellTitleNames))
    # 返回结果的行数
    row_cnt = len(rows)
    print("结果共%s 行"%row_cnt)
    if row_cnt == 0:
        rows.append(['-']*len(table_head_en))
        row_cnt=1
    # 创建excel文件与工作集sheet
    workbook = xlsxwriter.Workbook(excel_name)
    # 结果集大小，Excel最大行数 1048576， 超过的话 重新建立sheet
    sheet_cnt = math.ceil(row_cnt/1048575)
    max_cnt = 1048576
    # 创建sheet页
    for sheet in range(0, sheet_cnt):
        # 创建excel的sheet
        copy_sheet = "_副本%s"%(sheet+1)
        worksheet = workbook.add_worksheet(worksheet_name+copy_sheet)
        # 在excel的sheet中写入表头
        worksheet.write_row('A1', table_head_zh)

        # Excel 最大行数
        for i in range(0, max_cnt):
            index = i+max_cnt*sheet

            # 获取全部结果集的子集，写入到excel中
            if row_cnt >= index+1:
                sub_rows=[]
                for sub_index in sub_head_index:
                    if sub_index==-1:
                        sub_rows.append("-")
                    else:
                        sub_rows.append(rows[index][sub_index])
                # worksheet.write_row("A%s"%(i+2),rows[index])
                worksheet.write_row("A%s"%(i+2),sub_rows)

            else:
                break
    workbook.close()

if __name__ == '__main__':
    ExportExcel()
    print("导出excell成功")
    sys.exit(0)
