import 'package:flutter/material.dart';

class HomePageProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}