// 使用该库中的 rootBundle 对象来读取 perosn.json 文件
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../modle/category.dart';

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
          return _leftInkWel(index);
        },
      ),
    );
  }

  // 每一个子项
  Widget _leftInkWel(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: Colors.white,
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
      print(data);
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      // category.data.forEach((item) => print(item));
    });
  }
}
