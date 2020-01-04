// 使用该库中的 rootBundle 对象来读取 perosn.json 文件
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../modle/category.dart';
import '../modle/categoryGoodsList.dart';
// 状态管理
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

// 因为接口数据异常 所以此处使用 json 数据模拟一下
// Flutter 中的 JSON 解析  https://juejin.im/post/5c98a5ed51882520f2089450

// 读取 assets 文件夹中的 category.json 文件
Future<String> _loadCategoryJson() async {
  return await rootBundle.loadString('assets/category.json');
}

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商城分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CategoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  // 每一个子项
  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(list[index].mallCategoryName,
            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }

  // 获取商城分类数据
  void _getCategory() async {
    // 模拟json 数据
    // var val = await _loadCategoryJson();
    // var data = json.decode(val.toString());
    // CategoryModel category = CategoryModel.fromJson(data);
    // setState(() {
    //   list = category.data;
    // });

    // 接口调用
    await commonRequest('getCategory').then((val) {
      var data = json.decode(val.toString());
      // print(data);
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto);
    });
  }
}

// 右侧顶部二级分类
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Container(child: Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          width: ScreenUtil().setWidth(570),
          height: ScreenUtil().setHeight(80),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    ));
  }

  // 小类的每一项
  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item.mallSubName,
            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }
}

// 修改步骤：
// 在Container Widget外层加入一个Provie widget。
// 修改ListView Widget的itemCount选项为childCategory.childCategoryList.length。
// 修改itemBuilder里的传值选项为return _rightInkWell(childCategory.childCategoryList[index]);

//商品列表，可以上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  List list = [];

  @override
  void initState() {
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(570),
      height: ScreenUtil().setHeight(1000),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _ListItemWidget(index);
        },
      ),
    );
  }

  void _getGoodsList() async {
    var data = {'categoryId': '4', 'categorySubId': "", 'page': 1};
    await commonRequest('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // print('分类商品列表：>>>>>>>>>>>>>');
      // print(goodsList.data[0].goodsName);
      setState(() {
        list = goodsList.data;
      });
    });
  }

  // 组合_goodsImage _goodsName _goodsPrice成一个
  Widget _ListItemWidget(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(index),
            Column(
              children: <Widget>[_goodsName(index), _goodsPrice(index)],
            )
          ],
        ),
      ),
    );
  }

  // 制作图片组件
  Widget _goodsImage(index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  // 制作商品名称组件
  Widget _goodsName(index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(list[index].goodsName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: ScreenUtil().setSp(28))),
    );
  }

  // 制作商品价格组件
  Widget _goodsPrice(index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text('价格:￥${list[index].presentPrice}',
              style: TextStyle(
                  color: Colors.pink, fontSize: ScreenUtil().setSp(30))),
          Text('价格:￥${list[index].oriPrice}',
              style: TextStyle(
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough)),
        ],
      ),
    );
  }
}
