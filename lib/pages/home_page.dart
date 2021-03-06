import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

// 路由
import '../routers/application.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/currentIndex.dart';
import '../model/category.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // 火爆专区初始数据
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _getHotGoods();
    print('数据初始化');
  }

  String homePageContent = '正在获取数据';

  // 直接 FutureBuilder 获取数据 就不初始化了
  // @override
  // void initState() {
  //   getHomePageContent().then((val) {
  //     setState(() {
  //       homePageContent = val.toString();
  //     });
  //   });
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      // FutureBuilder Widget 用来等待异步请求的
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); // 顶部轮播组件数
            List<Map> navigatorList =
                (data['data']['category'] as List).cast(); //类别列表
            String advertesPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
            String leaderImage = data['data']['shopInfo']['leaderImage']; //店长图片
            String leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast(); //商品推荐列表
            String floor1Title =
                data['data']['floor1Pic']['PICTURE_ADDRESS']; // 楼层1的标题图片
            String floor2Title =
                data['data']['floor2Pic']['PICTURE_ADDRESS']; // 楼层1的标题图片
            String floor3Title =
                data['data']['floor3Pic']['PICTURE_ADDRESS']; // 楼层1的标题图片
            List<Map> floor1Goods =
                (data['data']['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2Goods =
                (data['data']['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3Goods =
                (data['data']['floor3'] as List).cast(); //楼层1商品和图片

            return EasyRefresh(
              // 自定义底部
              footer: ClassicalFooter(
                bgColor: Colors.white,
                textColor: Colors.pink,
                infoText: '加载中',
                noMoreText: '已经滑动到底部',
                loadReadyText: '上拉加载...',
                infoColor: Colors.pink,
              ),
              child: ListView(
                children: <Widget>[
                  // 页面顶部轮播组件
                  SwiperDiy(
                    swiperDataList: swiperDataList,
                  ),
                  // 导航栏目
                  TopNavigator(
                    navigatorList: navigatorList,
                  ),
                  // 广告图片
                  AdBanner(adPicture: advertesPicture),
                  // 拨打电话
                  LeaderPhone(
                    leaderImage: leaderImage,
                    leaderPhone: leaderPhone,
                  ),
                  // 商品推荐
                  Recommend(
                    recommendList: recommendList,
                  ),
                  FloorTitle(pictureAddress: floor1Title),
                  FloorContent(floorGoodsList: floor1Goods),
                  FloorTitle(pictureAddress: floor2Title),
                  FloorContent(floorGoodsList: floor2Goods),
                  FloorTitle(pictureAddress: floor3Title),
                  FloorContent(floorGoodsList: floor3Goods),
                  _hotGoods()
                ],
              ),
              onLoad: () async {
                print('开始加载更多');
                // var formPage = {'page': page};
                // await getHomePageBelowConten(formPage).then((val) {
                //   var data = json.decode(val.toString());
                //   List<Map> newGoodsList = (data['data'] as List).cast();
                //   setState(() {
                //     hotGoodsList.addAll(newGoodsList);
                //     page++;
                //   });
                // });
                _getHotGoods();
              },
            );
          } else {
            return Center(
              child: Text('加载中。。。'),
            );
          }
        },
      ),
    );
  }

  // 获取火爆专区数据
  void _getHotGoods() {
    var formPage = {'page': page};
    getHomePageBelowConten(formPage).then((val) {
      // print(val);
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
    child: Text('火爆专区'),
  );

  // 火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      // 包装成 List widget
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            print('点击了火爆商品');
            Application.router
                .navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black26),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2, // 每一行两列
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  // 火爆专区组合
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  // 上句话简写
  // SwiperDiy({this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    // iphone6 作为参考设计尺寸
    // 放在全局引入
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // print('设备宽度:${ScreenUtil.screenWidth}');
    // print('设备高度:${ScreenUtil.screenHeight}');
    // print('设备像素密度:${ScreenUtil.pixelRatio}');
    return Container(
      height: ScreenUtil().setHeight(333.0),
      width: ScreenUtil().setWidth(750.0),
      child: Swiper(
        itemBuilder: (BuildContext content, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(
                  context, "/detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: Image.network("${swiperDataList[index]['image']}",
                fit: BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 导航区域
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  // 把每一个导航看做一个单独的组件
  Widget _gridViewItemUI(BuildContext context, index, item) {
    return InkWell(
      onTap: () {
        print('点击导航');
        _goCategory(context, index, item['mallCategoryId']);
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  void _goCategory(BuildContext context, int index, String categoryId) async {
    await commonRequest('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      List list = category.data;
      Provide.value<ChildCategory>(context).changeCategory(categoryId, index);
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[index].bxMallSubDto, categoryId);
      Provide.value<CurrentIndexProvide>(context).changeIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 边界判断
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }

    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320.0),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), // 禁止回弹避免与easyfresh冲突
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          tempIndex++;
          return _gridViewItemUI(context, tempIndex, item);
        }).toList(),
      ),
    );
  }
}

// 广告banner组件
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      color: Colors.white,
      child: Image.network(adPicture),
    );
  }
}

// 拨打电话组件
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(onTap: _launchURL, child: Image.network(leaderImage)),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// 商品推荐模块
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  // 推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text('商品推荐', style: TextStyle(color: Colors.pink)),
    );
  }

  // 商品单独项的方法
  Widget _itemWidget(context, index) {
    // InkWell 可点击的item
    return InkWell(
      onTap: () {
        Application.router.navigateTo(
            context, "/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(330),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 横向列表组件
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(356),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _itemWidget(context, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

// 编写楼层模块

// 楼层标题组件
class FloorTitle extends StatelessWidget {
  final String pictureAddress;
  FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[_firstRow(context), _otherGoods(context)],
    ));
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
          Application.router
              .navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4])
      ],
    );
  }
}
