from imp import reload

import requests
import time
from bs4 import BeautifulSoup
# import BeautifulSoup
import sys
reload(sys)

headers = {'Cookie': '_T_WM=9136283cc44d10a7a33629a4d4303f60; WEIBOCN_WM=ig_1002; gsid_CTandWM=4u6Ke7771Groy0t0BZTX47kTp2t; SUB=_2A255hO7VDeTxGedJ71oX8S_Nzj-IHXVahvKdrDV6PUJbrdBeLWL5kW08pEHt54KwmWZ3woaUCvXUhejMfw..; H5_INDEX=3; H5_INDEX_TITLE=andrewgyq; M_WEIBOCN_PARAMS=from%3Dindex%26rl%3D1%26featurecode%3D20000181%26luicode%3D10000011%26lfid%3D1005051965241925%26fid%3D1005051965241925_-_WEIBO_SECOND_PROFILE_WEIBO%26uicode%3D10000012Host:m.weibo.cn',
           'Host':'m.weibo.cn',
           'User-Agent':'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36',
           'Accept':'application/json, text/javascript, */*; q=0.01'
           }

# r = requests.get('http://m.weibo.cn/u/1632069872', headers=headers)
r = requests.get('http://m.weibo.cn/u/1005051792328230', headers=headers)
soup = BeautifulSoup(r.text)
print("soup:",soup)
containerid = soup.find_all('script')[1].get_text()[42:58]
print("containerid:",containerid)