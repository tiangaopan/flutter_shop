import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  BuildContext mContext;

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Provide<DetailsInfoProvide>(
      builder: (
        context,
        child,
        value,
      ) {
        var goodsInfo =
            Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if (goodsInfo != null) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNum(goodsInfo.goodsSerialNumber)
              ],
            ),
          );
        } else {
          return Text('正在加载中....');
        }
      },
    );
  }

  //商品图片
  Widget _goodsImage(url) {
    return Image.network(url, width: MediaQuery.of(mContext).size.width);
  }

  //商品名称
  Widget _goodsName(name) {
    return Container(
      width: MediaQuery.of(mContext).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Text(
        name,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  //商品编号
  Widget _goodsNum(num) {
    return Container(
      width: MediaQuery.of(mContext).size.width,
      padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '编号:$num',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
