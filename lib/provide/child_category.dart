import 'package:flutter/material.dart';
import '../modle/category.dart';

// ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; //商品列表
  int categoryIndex = 0; //大类索引
  int childIndex = 0; // 子类高亮索引

  //点击大类时切换逻辑
  getChildCategory(List<BxMallSubDto> list) {
    // 点击大类 子类高亮索引归零
    childIndex = 0;

    // 添加全部(声明一个all 的类)
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引逻辑
  changeChildIndex(int index) {
    childIndex = index;
    notifyListeners();
  }
}
