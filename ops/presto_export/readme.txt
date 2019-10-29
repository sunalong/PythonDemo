数据平台大表的导出：
    遍历目录，执行sql文件，将执行结果发送到指定目录


设计思路：
    1.每分钟 遍历目录/data/user/sqoop/export/，如果以 .sql 结尾，执行sql文件，执行完毕后，添加后缀 _ok
        [sqoop@yhbi-ftp-03 sql]$ pwd
        /home/sqoop/export/sql
    2.生成的文件以 .sql文件的文件名命名，后续为xlsx
        [sqoop@yhbi-ftp-03 excel]$ pwd
        /home/sqoop/export/excel
    3.以xlsx文件生成md5,以.sql文件的文件名命名，后缀为.md5
        如果有md5文件存在，则说明些xlsx已经完完毕，数据平台那边可读取


脚本单独部署在 yhbi-ftp-03 机器上：
    [sqoop@yhbi-ftp-03 data_platform_export]$ pwd
    /home/sqoop/data_platform_export