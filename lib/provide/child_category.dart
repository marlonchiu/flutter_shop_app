import 'package:flutter/material.dart';
import '../modle/category.dart';

// ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; //商品列表
  int categoryIndex = 0; //大类索引
  int childIndex = 0; // 子类高亮索引
  String categoryId = '4'; // 默认大类的Id('白酒的')
  String categorySubId = ''; // 子类 ID, 默认为 ''

  // 上拉加载更多使用
  int page = 1; //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的标识

  //点击大类时切换逻辑
  getChildCategory(List<BxMallSubDto> list, String id) {
    categoryId = id;
    // 点击大类 子类高亮索引归零
    childIndex = 0;
    // 点击大类时要清空子类
    categorySubId = '';
    // 改变大类
    page = 1;
    noMoreText = '';

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
  changeChildIndex(int index, String id) {
    childIndex = index;
    categorySubId = id;

    page = 1;
    noMoreText = '';

    notifyListeners();
  }

  // 页面增加
  addPage() {
    page++;
  }

  // 改变noMoreText数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
