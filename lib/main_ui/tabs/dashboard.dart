import 'package:flutter/material.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:provider/src/provider.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('Dashboard')
      ),
    );
  }
}
