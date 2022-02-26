import 'package:alpha/main_ui/tabs/dashboard_tab/dashboard.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:alpha/components/app_bar.dart';
import 'package:alpha/main_ui/tabs/auction_tab/auction.dart';
import 'package:alpha/main_ui/tabs/profile_tab/profile.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:provider/provider.dart';

class MainUi extends StatefulWidget {
  const MainUi({Key? key}) : super(key: key);

  @override
  _MainUiState createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {

  // bottomNavigation
  late AuctionTab auctionTab;
  late DashboardTab dashboardTab;
  late ProfileTab profileTab;

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    auctionTab = const AuctionTab();
    dashboardTab = const DashboardTab();
    profileTab = const ProfileTab();
  }

  void _onItemTapped(int index) {
    context.read<MainModel>().changeTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.homeAppBar(context),
        body: GlobalMsgWrapper(
          IndexedStack(
            index: context.watch<MainModel>().tabIndex,
            children: [
              auctionTab,
              dashboardTab,
              profileTab,
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.local_mall_rounded),
              label: 'Auction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: context.watch<MainModel>().tabIndex,
          onTap: _onItemTapped,
        )
    );
  }
}