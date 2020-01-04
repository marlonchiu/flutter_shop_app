// 使用该库中的 rootBundle 对象来读取 perosn.json 文件
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../modle/category.dart';
// 因为接口数据异常 所以此处使用 json 数据模拟一下

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
    // _getCategory();
    return Container(
      child: Center(
        child: Text('商城分类'),
      ),
    );
  }
}

// 左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 获取商城分类数据

  void _getCategory() async {
    // 模拟json 数据
    var val = await _loadCategoryJson();
    var data = json.decode(val.toString());
    print(data['data']);

    // 接口调用
    // await commonRequest('getCategory').then((val) {

    //   var data = json.decode(val.toString());
    //   print(data);
    //   CategoryModel category = CategoryModel.fromJson(data);
    //   print(category);
    //   category.data.forEach((item) => print(item));
    // });
  }
}
