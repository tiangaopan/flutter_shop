import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import 'provide/counter.dart';
import 'provide/child_category.dart';
import 'provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';
import 'provide/details_info.dart';
import 'provide/cart.dart';
import 'dart:io';
import 'provide/currentIndex.dart';
void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var detailsInfo = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentProvide = CurrentIndexProvide();
  var categoryGoodsListProvider = CategoryGoodsListProvider();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentProvide))
    ..provide(Provider<CategoryGoodsListProvider>.value(categoryGoodsListProvider))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfo));

  runApp(ProviderNode(child: MyApp(), providers: providers));

  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
