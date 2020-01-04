import 'package:flutter/material.dart';
import '../modle/category.dart';

// ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; //商品列表
  int categoryIndex = 0; //大类索引
  int childIndex = 0; // 大类索引

  //点击大类时更换
  getChildCategory(List<BxMallSubDto> list) {
    childCategoryList = list;
    notifyListeners();
  }
}
