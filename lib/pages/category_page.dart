import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../modle/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Center(
        child: Text('商城分类'),
      ),
    );
  }

  // 获取商城分类数据
  void _getCategory() async {
    await commonRequest('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryBigListModel list = CategoryBigListModel.fromJson(data['data']);
      list.data.forEach((item) => print(item.mallCategoryName));
      // print(data);
    });
  }
}
