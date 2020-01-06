import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 商品详情页的 说明区域UI
class DetailsExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 10),
      child: Text('说明：> 急速送达 > 正品保证',
          style:
              TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30))),
    );
  }
}
