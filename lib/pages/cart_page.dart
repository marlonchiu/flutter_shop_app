import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> testList = [];

  @override
  Widget build(BuildContext context) {
    _show(); //每次进入前进行显示
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: ListView.builder(
              itemCount: testList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(testList[index]),
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              _add();
            },
            child: Text('增加'),
          ),
          RaisedButton(
            onPressed: () {
              _clear();
            },
            child: Text('清空'),
          )
        ],
      ),
    );
  }

  // 增加方法
  void _add() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 搞一个临时变量
    String temp = '技术胖是最棒的！！！';
    testList.add(temp);
    prefs.setStringList('testInfo', testList);
    _show();
  }

  // 显示的方法
  void _show() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('testInfo') != null) {
      setState(() {
        testList = prefs.getStringList('testInfo');
      });
    }
  }

  // 清空的方法
  void _clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear(); //全部清空
    prefs.remove('testInfo');
    setState(() {
      testList = [];
    });
  }
}
