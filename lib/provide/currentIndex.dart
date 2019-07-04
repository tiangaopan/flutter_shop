import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0;

  changeIndex(newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

}
