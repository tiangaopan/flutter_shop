import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;

  //从后台获取商品数据  ui和业务逻辑分离
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request("getGoodGetailById", formData: formData).then((value) {
      goodsInfo = DetailsModel.fromJson(jsonDecode(value.toString()));
      notifyListeners();
    });
  }
}
