from distutils.core import setup

setup(name="module_message"  # 包名
      , version="1.0"  # 版本
      , description="自定义发送和接收消息的模块"  # 描述信息
      , long_description="完整的描述信息"  # 完整描述信息
      , author="sunalong"  # 作者
      , author_email="466210864@qq.com"  # 邮箱
      , url="www.itcode.com"  # 主页
      , py_modules=["module_message.receive_message"
                  , "module_message.send_message"]
      )
