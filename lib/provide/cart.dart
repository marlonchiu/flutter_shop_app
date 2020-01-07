import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier {
  String cartString = "[]"; // 字符串变量（后期会换成对象）

  // 添加商品到购物车
  save(goodsId, goodsName, count, price, images) async {
    // 初始化SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // 判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    // 如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    // 把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    // 声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; // 默认为没有
    int indexVal = 0; // 用于进行循环的索引使用,因为dart 是没有索引的
    tempList.forEach((item) {
      // 如果存在，数量进行+1操作
      if (item['goodsId'] == goodsId) {
        tempList[indexVal]['count'] = item['count'] + 1;
        isHave = true;
      }
      indexVal++;
    });

    // 如果没有，进行增加
    if (!isHave) {
      tempList.add({
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images
      });
    }

    // 把字符串进行encode操作
    cartString = json.encode(tempList).toString();
    print(cartString);
    // 进行持久化
    preferences.setString('cartInfo', cartString);
    notifyListeners();
  }

  // 清空购物车
  remove() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('cartInfo');
    print('清空完成-----------------');
    notifyListeners();
  }
}
