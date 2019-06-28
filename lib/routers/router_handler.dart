import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
  String goodsId = parameters['id'].first;
  print('index details goodsId is ${goodsId}');
  return DetailsPage(goodsId: goodsId);
});
