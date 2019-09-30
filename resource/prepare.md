# 本项目所参考的资源

* [shenghy GitHub 项目：一个Flutter的电商实战项目](https://github.com/shenghy/flutter_shop)

* [pheromone：基于Flutter的电商学习项目](https://github.com/pheromone/flutter_shop)

* [API接口](https://github.com/pheromone/flutter_shop/blob/master/lib/config/service_url.dart) 提供接口

  ```dart
  // flutter_shop/lib/config/service_url.dart  2019-09-04
  // 此端口针对于正版用户开放，可自行fiddle获取。
  const serviceUrl = 'http://v.jspang.com:8088/baixing/';
  const servicePath = {
     'homePageContent':serviceUrl + 'wxmini/homePageContent', // 商店首页信息
     'homePageBelowConten':serviceUrl + 'wxmini/homePageBelowConten', // 首页热卖商品
     'getCategory':serviceUrl + 'wxmini/getCategory',  // 商品类别信息
     'getMallGoods':serviceUrl + 'wxmini/getMallGoods',  // 商品分类页面商品列表
     'getGoodDetailById':serviceUrl + 'wxmini/getGoodDetailById',  // 商品详情
  };
  ```
