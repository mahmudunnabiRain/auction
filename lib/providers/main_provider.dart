import 'package:flutter/material.dart';

class MainModel with ChangeNotifier {

  // App parameters
  final String _appName = 'AuctionRain';
  String get appName => _appName;
  final MaterialColor _appColor = Colors.pink;
  MaterialColor get appColor => _appColor;

  // Home bottomView current tab state
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  void changeTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

}