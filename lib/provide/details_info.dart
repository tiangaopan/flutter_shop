import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;
  bool isLeft = true;
  bool isRight = false;

  //从后台获取商品数据  ui和业务逻辑分离
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request("getGoodDetailById", formData: formData).then((value) {
      goodsInfo = DetailsModel.fromJson(json.decode(value.toString()));
      notifyListeners();
    });
  }

  //tabbar的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}
