import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '欢迎来到美好人间美好人间';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('美好世界'),
      ),
      body: Container(
        height: 1000,
        child: Column(
          children: <Widget>[
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                  // 修饰文本框
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '美女类型',
                  helperText: '请输入您喜欢的类型'),
              autofocus: false, // 否则会自动打开编辑输入法
            ),
            RaisedButton(
              onPressed: _choiceAction,
              child: Text('选择完毕'),
            ),
            Text(
              showText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }

  void _choiceAction() {
    print('开始选择你喜欢的类型............');
    if (typeController.text.toString() == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('美女类型不能为空'),
              ));
    } else {
      getHttp(typeController.text.toString()).then((val){
        setState(() {
          showText = val['data']['name'].toString();
        });      
      });
    }
  }

  Future getHttp(String TypeText) async {
    try {
      Response response;
      var data = {'name': TypeText};
      response = await Dio().get(
          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
          queryParameters: data);
      // print(response);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}
