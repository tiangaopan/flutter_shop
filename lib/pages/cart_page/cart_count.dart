import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class CartCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.instance.setWidth(165),
      margin: EdgeInsets.only(top: 5),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: <Widget>[_reduceBtn(),_countArea(), _addBtn() ],
      ),
    );
  }

  //减少按钮
  Widget _reduceBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil.instance.setWidth(45),
        height: ScreenUtil.instance.setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: Colors.black12))),
        child: Text('-'),
      ),
    );
  }

  //加按钮
  Widget _addBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil.instance.setWidth(45),
        height: ScreenUtil.instance.setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  //中间数量显示区域
  Widget _countArea(){

    return Container(
      width: ScreenUtil.instance.setWidth(80),
      height: ScreenUtil.instance.setWidth(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('1'),
    );
  }
}
