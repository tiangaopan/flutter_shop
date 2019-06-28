import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.instance.setWidth(220),
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(width: 1, color: Colors.black12),
      )),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return _leftInkWell(index);
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      CategoryModel categoryModel = CategoryModel.fromJson(data);
      setState(() {
        list = categoryModel.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      _getGoodsList(1);
    });
  }

  void _getGoodsList(int page) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': page
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = jsonDecode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }

  Widget _leftInkWell(int index) {
    bool isClick = index == listIndex;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, list[index].mallCategoryId);
        _getGoodsList(1);
      },
      child: Container(
        height: ScreenUtil.instance.setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 13),
        decoration: BoxDecoration(
            color: isClick ? Colors.black12 : Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            )),
        child: Text(list[index].mallCategoryName),
      ),
    );
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  //final List list = ['名酒', '宝丰', '北京二锅头', '大明', '五粮液', '舍得', '茅台', '散白'];

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child1, childCategory) {
        return Container(
          child: Container(
            height: ScreenUtil().setHeight(80),
            width: MediaQuery.of(context).size.width -
                ScreenUtil.instance.setWidth(220),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black12),
                )),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: childCategory.childCategoryList.length,
                itemBuilder: (context, index) {
                  return _rightInkWell(
                      index, childCategory.childCategoryList[index]);
                }),
          ),
        );
      },
    );
  }

  Widget _rightInkWell(index, BxMallSubDto item) {
    var isClick = (index == Provide.value<ChildCategory>(context).childIndex
        ? true
        : false);

    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(1);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: 14, color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  void _getGoodsList(int page) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': page
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = jsonDecode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvider>(builder: (context, child, value) {
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          //说明切换了，需要把列表位置放到最上面
          scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('进入页面第一次初始化....... $e');
      }

      if (value.goodsList.length == 0) {
        return Center(
          child: Text('暂无数据'),
        );
      } else {
        return Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width -
                    ScreenUtil.instance.setWidth(220),
                child: EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText:
                        Provide.value<ChildCategory>(context).noMoreText,
                    moreInfo: '加载中...',
                    loadReadyText: '上拉加载...',
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return _listWidget(value.goodsList, index);
                    },
                    itemCount: value.goodsList.length,
                  ),
                  loadMore: () async {
                    Provide.value<ChildCategory>(context).addPage();
                    _getMoreList();
                  },
                )));
      }
    });
  }

  void _getMoreList() async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = jsonDecode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        print("没有数据了");

        Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            fontSize: 16.0,
            timeInSecForIos: 1,
            textColor: Colors.deepPurpleAccent);
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');

      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .addGoodsList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(newList, index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(570),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _goodsPrice(newList, index) {
    return Container(
      width: ScreenUtil().setWidth(570),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Text(
            '价格:¥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink, fontSize: 16),
          ),
          Text(
            '¥${newList[index].oriPrice}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 16,
                color: Colors.black12),
          ),
        ],
      ),
    );
  }

  Widget _listWidget(newList, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            )
          ],
        ),
      ),
    );
  }
}
