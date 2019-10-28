"""
"""
import os
import requests
import logging

import threadpool

class WbGrawler():
    def __init__(self,containerid,nick_name,start=1,end=500):
        """
        参数的初始化
        :return:
        """
        self.baseurl = "https://m.weibo.cn/api/container/getIndex?containerid="+str(containerid)+"&"
        self.headers = {
            "Host": "m.weibo.cn",
            "Referer": "https://m.weibo.cn/p/"+str(containerid),
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36",
            "X-Requested-with": "XMLHttpRequest"
        }
        self.start_pages = start
        self.end_pages = end
        # 图片保存位置
        self.pic_dir = "/Users/along/Desktop/"+ nick_name

        # 如果目录不存在，创建目录
        if not os.path.exists(self.pic_dir):
            os.makedirs(self.pic_dir)
            print("目录：" + self.pic_dir + "   创建成功")


        self.logger = logging.getLogger()
        self.logger.setLevel(logging.INFO)

    def getPageJson(self, page):
        """
        获取单个页面的json数据
        :param page:传入的page参数
        :return:返回页面响应的json数据
        """
        url = self.baseurl + "page=%d" % page
        try:
            response = requests.get(url, self.headers)
            if response.status_code == 200:
                return response.json()
        except requests.ConnectionError as e:
            print("errorJsonURL:",url)
            self.logger.error("error",e.args)

    def parserJson(self, json):
        """
        解析json数据得到目标数据
        :param json: 传入的json数据
        :return: 返回目标数据
        """

        # nick_name = json.get('data').get('cards')[0].get('mblog').get('user').get('screen_name')  # 博主昵称
        # self.pic_dir = self.root_path + "/" + nick_name
        # # 如果目录不存在，创建目录
        # if not os.path.exists(self.pic_dir):
        #     os.makedirs(self.pic_dir)
        #     print("目录：" + self.pic_dir + "   创建成功")
        print("json:",json)
        items = json.get("data").get("cards")
        for item in items:
            print("item:",item)
            pics = item.get("mblog").get("pics")
            picList = []
            # 有些微博没有配图，所以需要加一个判断，方便后面遍历不会出错
            if pics is not None:
                for pic in pics:
                    pic_dict = {}
                    pic_dict["pid"] = pic.get("pid")
                    pic_dict["url"] = pic.get("large").get("url")
                    picList.append(pic_dict)
            yield picList

    def imgDownload(self,results):
        """
        下载图片
        :param results:
        :return:
        """
        for result in results:
            for img_dict in result:
                if img_dict.get("url").endswith('.jpg'):  # 保存jpg图片
                    suffix = '.jpg'
                if img_dict.get("url").endswith('.gif'):  # 保存gif图片
                    suffix = '.gif'

                img_name = img_dict.get("pid") + suffix
                try:
                    img_data = requests.get(img_dict.get("url")).content
                    with open(self.pic_dir+"/"+img_name,"wb") as file:
                        file.write(img_data)
                        file.close()
                        print(img_name+"\tdownload successed!")
                except Exception as e:
                    self.logger.error(img_name+"\tdownload failed!",e.args)

    def startCrawler(self,page):
        page_json = self.getPageJson(page)
        results = self.parserJson(page_json)
        self.imgDownload(results)


if __name__ == '__main__':
    """
    containerid的获取：
    1.打开用户主页：https://weibo.com/p/1005051687902095/home?from=page_100505&mod=TAB&is_all=1#place
    2.在weibo.com前加个m.  如：https://m.weibo.com/p/1005051687902095/home?from=page_100505&mod=TAB&is_all=1#place
        然后访问，则url变成：https://m.weibo.cn/p/1005051687902095
    3.然后点击主页 https://m.weibo.cn/p/1005051687902095
    4.滑动到最下方：option+command+j
        再点击：查看他的全部微博
    """
    # 输入containerid,startPage,endPage
    # wg = WbGrawler('欧陽忍Shorio',2304131687902095,1,1000)
    # wg = WbGrawler('无肌肉不硬汉',2304135571216925,1,1000)
    # wg = WbGrawler('Fitpics',2304132954360244,1,1000)
    # wg = WbGrawler('女神图册',2304136525872699,1,1000)

    # wg = WbGrawler('姜黎明Momo',2304132916497573,1,1000)
    wg = WbGrawler('2304135707380106','健身汇精选',1,1000)
    wg = WbGrawler('2304135022385098','健身励志CLUB',1,1000)
    wg = WbGrawler('2304136085757683','燃脂大师',1,1000)
    wg = WbGrawler('2304133902891751','街头健身小芳',1,1000)
    wg = WbGrawler('2304135364117255','肌友大方',1,1000)
    wg = WbGrawler('2304135852465340','全球健身汇总',1,1000)
    wg = WbGrawler('2304135564345574','街头健身汇',1,1000)
    wg = WbGrawler('2304135066337241','北京健身汇',1,1000)
    wg = WbGrawler('2304131674411610','超级健身王',1,1000)
    wg = WbGrawler('2304133975175672','腹肌工场',1,1000)
    wg = WbGrawler('2304135707380106','健身汇精选',1,1000)
    wg = WbGrawler('2304135707380106','健身汇精选',1,1000)
    wg = WbGrawler('2304135707380106','健身汇精选',1,1000)
    wg = WbGrawler('2304135707380106','健身汇精选',1,1000)
    # wg = WbGrawler('刘亦菲',2304133261134763,1,1000)
    # wg = WbGrawler('杨幂',2304131195242865,1,1000)
    # wg = WbGrawler('胡歌',2304131223178222,1,1000)
    pool = threadpool.ThreadPool(10)
    reqs = threadpool.makeRequests(wg.startCrawler,range(wg.start_pages,wg.end_pages))
    [pool.putRequest(req) for req in reqs]
    # 等待所有的线程完成工作后退出
    pool.wait()
