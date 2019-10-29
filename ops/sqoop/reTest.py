# -*- coding: utf-8 -*-
"""
@time: 11/10/17 10:01 PM
@author:    zhaoshun
@contact:   tmby1314@163.com
@desc:
"""

import re

test = "xxx  Error asdfas "

Error = re.compile(r'Error')

# re.match(Error, test)
res = re.search(Error, test)

print(type(res.group(0)))

