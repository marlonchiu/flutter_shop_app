import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]"; // 字符串变量（后期会换成对象）
  List<CartInfoModel> cartList = []; // 商品列表对象
  double allPrice = 0; // 总价格
  int allGoodsCount = 0; // 商品总数量
  bool isAllChecked = true; //是否全选

  // 添加商品到购物车
  save(goodsId, goodsName, count, price, images) async {
    // 初始化SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //获取持久化存储的值
    cartString = preferences.getString('cartInfo');
    // 判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    // 如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    // 把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    // 声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; // 默认为没有
    int indexVal = 0; // 用于进行循环的索引使用,因为dart 是没有索引的
    allPrice = 0;
    allGoodsCount = 0;
    tempList.forEach((item) {
      // 如果存在，数量进行+1操作
      if (item['goodsId'] == goodsId) {
        tempList[indexVal]['count'] = item['count'] + 1;
        cartList[indexVal].count++;
        isHave = true;
      }
      if (item['isChecked']) {
        allPrice += cartList[indexVal].count * cartList[indexVal].price;
        allGoodsCount += cartList[indexVal].count;
      }
      indexVal++;
    });

    // 如果没有，进行增加
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isChecked': true // 默认选择
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));
      allPrice += count * price;
      allGoodsCount += count;
    }

    // 把字符串进行encode操作
    cartString = json.encode(tempList).toString();
    print(cartString);
    // 进行持久化
    preferences.setString('cartInfo', cartString);
    print(cartList.toString());
    notifyListeners();
  }

  // 清空购物车
  remove() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('cartInfo');
    cartList = [];
    print('清空完成-----------------');
    notifyListeners();
  }

  // 得到购物车中的商品
  getCartInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    //把cartList进行初始化，防止数据混乱
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      var middleList = json.decode(cartString.toString());
      allPrice = 0;
      allGoodsCount = 0;
      isAllChecked = true;
      // 转换为 List 类型
      List<Map> tempList = (middleList as List).cast();
      tempList.forEach((item) {
        if (item['isChecked']) {
          allPrice += item['count'] * item['price'];
          allGoodsCount += item['count'];
        } else {
          isAllChecked = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  // 删除 商品条目
  deleteOneGoods(String goodsId) async {
    // 获取持久化数据的方法可以单独封装一下
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    // 把字符串进行encode操作
    cartString = json.encode(tempList).toString();
    // 进行持久化
    preferences.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 切换商品选择状态
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    int tempIndex = 0; //循环使用索引
    int changeIndex = 0; //需要修改的索引
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson(); // 把对象变成Map值
    cartString = json.encode(tempList).toString(); //变成字符串
    preferences.setString('cartInfo', cartString); //进行持久化
    await getCartInfo(); //重新读取列表
  }

  // 点击全选按钮操作
  changeAllCheckBtnState(bool isChecked) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();

    List<Map> newList = []; //新建一个List，用于组成新的持久化数据。
    for (var item in tempList) {
      var newItem = item; //复制新的变量，因为Dart不让循环时修改原值
      newItem['isChecked'] = isChecked; //改变选中状态
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString(); //形成字符串
    preferences.setString('cartInfo', cartString); //进行持久化
    await getCartInfo();
  }

  // 数量加减操作
  addOrReduceAction(CartInfoModel cartItem, String todo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();

    int tempIndex = 0; //循环使用索引
    int changeIndex = 0; //需要修改的索引
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson(); // 把对象变成Map值
    cartString = json.encode(tempList).toString(); //变成字符串
    preferences.setString('cartInfo', cartString); //进行持久化
    await getCartInfo(); //重新读取列表
  }
}
