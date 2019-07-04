import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Provide<CartProvide>(builder: (context, child, val){
        return Row(
          children: <Widget>[_selectAllBtn(context), _allPriceArea(context), _goBtn(context)],
        );
      }),

    );
  }

  //全选
  Widget _selectAllBtn(context) {

    var isAllCheck = Provide.value<CartProvide>(context).isAllCheck;

    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            onChanged: (bool val) {
              Provide.value<CartProvide>(context).changeAllCheck(val);
            },
            activeColor: Colors.pink,
          ),
          Text('全选')
        ],
      ),
    );
  }

  Widget _allPriceArea(context) {

    double allPrice = Provide.value<CartProvide>(context).allPrice;

    return Container(
      width: ScreenUtil.instance.setWidth(500),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil.instance.setWidth(300),
                child: Text(
                  '合计',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil.instance.setWidth(200),
                child: Text(
                  '¥${allPrice}',
                  style: TextStyle(fontSize: 18, color: Colors.pink),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenUtil.instance.setWidth(500),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免费配送，预约免配送费',
              style: TextStyle(color: Colors.black38, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  //结算按钮
  Widget _goBtn(context) {
    int allGoodsCount = Provide.value<CartProvide>(context).allGoodsCount;
    return Container(
      width: ScreenUtil.instance.setWidth(260),
      padding: EdgeInsets.only(left: 5),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.pink, borderRadius: BorderRadius.circular(3.0)),
          child: Text(
            '结算(${allGoodsCount})',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
