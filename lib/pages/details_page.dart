import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  // 最新版本  不用写key了
  // DetailsPage({Key key, this.goodsId}) : super(key: key);
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('商品ID为：${goodsId}'));
  }
}
