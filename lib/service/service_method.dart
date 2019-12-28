import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 编写一个 公共方法，方法返回一个Future对象
Future commonRequest(url, {formData}) async {
  try {
    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR: ======> ${e}');
  }
}

// 编写一个getHomePageContent方法，方法返回一个Future对象
Future getHomePageContent() async {
  // 模拟经纬度地理位置
  var formData = {'lon': '115.02932', 'lat': '35.76189'};
  return commonRequest('homePageContent', formData: formData);
  // try {
  //   print('开始获取首页数据...............');
  //   Response response;
  //   Dio dio = new Dio();
  //   dio.options.contentType =
  //       ContentType.parse("application/x-www-form-urlencoded");
  //   // 模拟经纬度地理位置
  //   var formData = {'lon': '115.02932', 'lat': '35.76189'};
  //   response = await dio.post(servicePath['homePageContent'], data: formData);
  //   if (response.statusCode == 200) {
  //     return response.data;
  //   } else {
  //     throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
  //   }
  // } catch (e) {
  //   return print('ERROR: ======> ${e}');
  // }
}

// 获取火爆商品
Future getHomePageBelowConten(formPage) async {
  return commonRequest('homePageBelowConten', formData:formPage);
}
