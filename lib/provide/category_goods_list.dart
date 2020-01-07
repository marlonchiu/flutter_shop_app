import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = []; //子类商品列表

  //更换商品列表
  getGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }

  // 获取更多商品列表
  getMoreList(List<CategoryListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
