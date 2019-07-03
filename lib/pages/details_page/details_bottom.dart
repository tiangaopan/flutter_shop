import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import '../../provide/cart.dart';


class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil.instance.setHeight(100),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async{

            },
            child: Container(
              width: MediaQuery.of(context).size.width / 5,

              alignment: Alignment.center,
              child: Icon(Icons.shopping_cart, size: 35, color: Colors.pink,),
            ),
          ),
          InkWell(
            onTap: () async {

              await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
            },
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width * 4 / 10,
              alignment: Alignment.center,
              child: Text('加入购物车', style: TextStyle(color: Colors.white, fontSize: 18),),
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
              child: Text('立即购买', style: TextStyle(color: Colors.white, fontSize: 18),),
            ),
          ),
        ],
      ),
    );
  }
}
