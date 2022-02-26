import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increase() {
    _count++;
    notifyListeners();
  }
  void decrease() {
    _count--;
    notifyListeners();
  }
}