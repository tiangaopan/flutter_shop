import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import 'cart_page/cart_item.dart';
import 'cart_page/cart_bottom.dart';
import 'cart_page/cart_count.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List castList = Provide.value<CartProvide>(context).cartInfoList;

            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, chiildCatgory) {
                    castList = Provide.value<CartProvide>(context).cartInfoList;
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return CartItem(item: castList[index]);
                      },
                      itemCount: castList.length,
                    );
                  },
                ),
                Positioned(
                  child: CartBottom(),
                  bottom: 0,
                  left: 0,
                )
              ],
            );
          } else {
            return Text('正在加载。。。');
          }
        },
        future: _getCartInfo(context),
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
