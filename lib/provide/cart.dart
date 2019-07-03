import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  final String CART_KEY = "Cart_KEY";
  List<CartInfoModel> cartInfoList = [];

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var cartStr = sp.getString(CART_KEY);
    var temp = cartStr == null ? [] : jsonDecode(cartStr.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int index = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[index]['count'] = item['count'] + 1;
        cartInfoList[index].count++;
        isHave = true;
      }
      index++;
    });

    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'image': images
      };
      tempList.add(newGoods);
      cartInfoList.add(CartInfoModel.fromJson(newGoods));
    }

    cartStr = jsonEncode(tempList).toString();
    sp.setString(CART_KEY, cartStr);
    notifyListeners();
  }

  remove() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(CART_KEY);
    cartInfoList = [];
    print('清空完成');
    notifyListeners();
  }


  getCartInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    cartInfoList = [];

    if(cartString != null){
      List<Map> tempList = (jsonDecode(cartString.toString()) as List).cast();
      tempList.forEach((item){
        cartInfoList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();

  }


}
