import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import '../pages/details_page/details_top_area.dart';
import '../pages/details_page/details_tabbar.dart';
import '../pages/details_page/details_web.dart';
import '../pages/details_page/details_bottom.dart';


class DetailsPage extends StatelessWidget {
  final String goodsId;

  const DetailsPage({Key key, this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详细介绍'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SafeArea(child: Stack(
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailsTopArea(),
                      DetailsTabbar(),
                      DetailsWeb(),
                    ],
                  ),
                ),

                Positioned(child: DetailsBottom(), bottom: 0,left: 0,),
              ],
            ));
          } else {
            return Text('加载中');
          }
        },
        future: _getBackInfo(context),
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
