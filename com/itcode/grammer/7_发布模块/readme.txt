发布模块步骤：

    先准备模块：module_message

    1.书写setup.py文件

    2.构建模块
        python3 setup.py build
    3.生成发布压缩包
        python3 setup.py sdist
        注意：要制作哪个版本的模块，就使用哪个版本的解释器执行！

    4.安装模块
        tar -zxvf hm_message-1.0.tar.gz
        python3 setup.py install

    5.卸载模块
        直接从安装目录下，把安装模块的 目录 删除就可以
        cd /usr/local/lib/python3.5/dist-packages/
        sudo rm -r hm_message*