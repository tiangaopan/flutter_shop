import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '4'; //大类id
  String subId = ''; //小类Id
  int page = 1; //列表页数
  String noMoreText = ''; //显示没有数据的文字

  //大类切换时显示全部
  getChildCategory(List<BxMallSubDto> list, String id) {
    childIndex = 0;
    categoryId = id;
    subId = '';
    page = 1;
    noMoreText = '';
    BxMallSubDto all = BxMallSubDto();
    all.mallSubName = '全部';
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(index, String id) {
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  //page改变的方法
  addPage() {
    page++;
  }

  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }
}
