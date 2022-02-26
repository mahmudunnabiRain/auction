import 'package:alpha/providers/counter_provider.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:truncate/truncate.dart';

class AuctionTab extends StatefulWidget {
  const AuctionTab({Key? key}) : super(key: key);

  @override
  _AuctionTabState createState() => _AuctionTabState();
}

class _AuctionTabState extends State<AuctionTab> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Auctions'),
      )
    );
  }

}


