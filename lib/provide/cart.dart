import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  final String CART_KEY = "Cart_KEY";
  List<CartInfoModel> cartInfoList = [];
  double allPrice = 0; //总价格
  int allGoodsCount = 0; //商品总数量
  bool isAllCheck = true; //是否全部选中

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var cartStr = sp.getString(CART_KEY);
    var temp = cartStr == null ? [] : jsonDecode(cartStr.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int index = 0;
    allPrice = 0;
    allGoodsCount = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[index]['count'] = item['count'] + 1;
        cartInfoList[index].count++;
        isHave = true;
      }
      if(item['isCheck']){
        allPrice += (cartInfoList[index].price * cartInfoList[index].count);
        allGoodsCount += cartInfoList[index].count;
      }
      index++;
    });

    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartInfoList.add(CartInfoModel.fromJson(newGoods));
      allPrice+=(count*price);
      allGoodsCount+=count;
    }
    cartStr = jsonEncode(tempList).toString();
    sp.setString(CART_KEY, cartStr);
    notifyListeners();
  }

  remove() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(CART_KEY);
    cartInfoList = [];
    allPrice = 0;
    allGoodsCount = 0;
    print('清空完成');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    cartInfoList = [];
    allGoodsCount = 0;
    allPrice = 0;

    if (cartString != null) {
      List<Map> tempList = (jsonDecode(cartString.toString()) as List).cast();
      isAllCheck = true;
      tempList.forEach((item) {
        var cartInfoModel = CartInfoModel.fromJson(item);
        cartInfoList.add(cartInfoModel);
        if (cartInfoModel.isCheck) {
          allGoodsCount += cartInfoModel.count;
          allPrice += (cartInfoModel.count * cartInfoModel.price);
        } else {
          isAllCheck = false;
        }
      });
    }
    notifyListeners();
  }

  //删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    List<Map> tempList = (jsonDecode(cartString) as List).cast();
    int tempIndex = 0;
    int deleteIndex = 0;

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        deleteIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(deleteIndex);
    cartString = jsonEncode(tempList);
    sp.setString(CART_KEY, cartString);
    await getCartInfo();
  }

  changeCheckState(CartInfoModel model) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    List<Map> tempList = (jsonDecode(cartString) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;

    tempList.forEach((item) {
      if (item['goodsId'] == model.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList[changeIndex] = model.toJson();
    cartString = jsonEncode(tempList);
    sp.setString(CART_KEY, cartString);
    await getCartInfo();
  }

  //点击全选按钮操作
  void changeAllCheck(bool val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    List<Map> tempList = (jsonDecode(cartString) as List).cast();
    for (int i = 0; i < tempList.length; i++) {
      tempList[i]['isCheck'] = val;
    }
    cartString = jsonEncode(tempList);
    sp.setString(CART_KEY, cartString);
    await getCartInfo();
  }

  //商品数量加减
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cartString = sp.getString(CART_KEY);
    List<Map> tempList = (jsonDecode(cartString) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if ("add" == todo) {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();

    cartString = jsonEncode(tempList);
    sp.setString(CART_KEY, cartString);
    await getCartInfo();
  }
}
