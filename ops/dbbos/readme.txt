功能描述：
    查询 dwd.dwd_dbbos__dayshopstock_sh 表中是否有门店数据漏抽，如果有，则预警到群:大数据作业异常预警

预警信息为：
    ---- 融通门店数据 ----
    表:dwd.dwd_dbbos__dayshopstock_sh
    抽取日期:20190919
    没有抽到数据的门店：
     9I34

异常后操作：
    如果有门店数据漏抽，则到群：融通数据 通知郑继明，让那边操作，一般都是日结没过
    那边操作完后，这边再指定门店重抽数据


具体操作步骤：

#解决方法：
登录task1:
    进入到目录：
        cd /data/app/dev/data_biz/etl/rongtong_datax/dbbos/dbbos__dayshopstock_sh
    备份文件：
        cp ../host_shop.txt ../host_shop.txt_bak
    修改文件：
        vim ../host_shop.txt
        只保留漏数据的那几个门店
    执行ETL:
        ./crontab_dbbos__dayshopstock_sh.sh


