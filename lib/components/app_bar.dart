import 'package:alpha/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CustomAppBar {

  static PreferredSizeWidget homeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
      titleSpacing: 0,
      elevation: 1,
      //title: Image.asset("assets/images/logo_title.png", height: 30,),
      title: Text(context.watch<MainModel>().appName, style: TextStyle(
        fontSize: 24 ,
        color: context.watch<MainModel>().appColor,
        fontWeight: FontWeight.w700,
      ),),
      centerTitle: true,
      iconTheme: IconThemeData(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
    );
  }

  static PreferredSizeWidget pageAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
      titleSpacing: 0,
      elevation: 1,
      //title: Image.asset("assets/images/logo_title.png", height: 36,),
      title: Text(title, style: TextStyle(
        fontSize: 18 ,
        color: context.watch<MainModel>().appColor,
        fontWeight: FontWeight.w700,
      ),),
      centerTitle: true,
      iconTheme: IconThemeData(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
    );
  }

}
