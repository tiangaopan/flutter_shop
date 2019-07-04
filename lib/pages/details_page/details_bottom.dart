import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import '../../provide/cart.dart';
import '../../provide/currentIndex.dart';

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo =
        Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil.instance.setHeight(150),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Colors.pink,
                  ),
                ),
              ),
              Provide<CartProvide>(
                builder: (context, child, value) {
                  int goodscount =
                      Provide.value<CartProvide>(context).allGoodsCount;
                  return Positioned(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.pink,
                          border: Border.all(width: 1, color: Colors.white)),
                      child: Text("${goodscount}", style: TextStyle(color: Colors.white),),
                    ),
                    top: 0,
                    right: 10,
                  );
                },
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context)
                  .save(goodsId, goodsName, count, price, images);
            },
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width * 4 / 10,
              alignment: Alignment.center,
              child: Text(
                '加入购物车',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context).remove();
            },
            child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width * 4 / 10,
              alignment: Alignment.center,
              child: Text(
                '立即购买',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
