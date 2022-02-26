import 'package:alpha/components/app_bar.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MyAuctionsPage extends StatefulWidget {
  const MyAuctionsPage({Key? key}) : super(key: key);

  @override
  _MyAuctionsPageState createState() => _MyAuctionsPageState();
}

class _MyAuctionsPageState extends State<MyAuctionsPage> {


  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.pageAppBar(context, 'Leave Board'),
      body: const Center(
        child: Text('My Auctions'),
      ),
    );
  }
}