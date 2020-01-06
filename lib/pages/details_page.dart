import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabbar.dart';
import './details_page/detals_web.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  // 最新版本  不用写key了
  // DetailsPage({Key key, this.goodsId}) : super(key: key);
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // print('返回上一页');
            Navigator.pop(context);
          },
        ),
        title: Text('商品详细页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: ListView(
                children: <Widget>[
                  // Text('商品ID为：${goodsId}'),
                  // 商品详情顶部
                  DetailsTopArea(),
                  // 商品详情说明
                  DetailsExplain(),
                  // 商品详情TabBar
                  DetailsTabBar(),
                  // 商品详情 信息
                  DetailsWeb(),
                ],
              ),
            );
          } else {
            return Text('加载中........');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
