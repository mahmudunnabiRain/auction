import 'package:alpha/pages/auction_details.dart';
import 'package:alpha/pages/my_auctions.dart';
import 'package:alpha/pages/post_auction.dart';
import 'package:flutter/material.dart';
import 'package:alpha/main_ui/main_ui.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainUi());
      case '/post-auction':
        return MaterialPageRoute(builder: (_) => const AuctionPostPage());
      case '/my-auctions':
        return MaterialPageRoute(builder: (_) => const MyAuctionsPage());
      case '/auction-details':
        return MaterialPageRoute(builder: (_) => AuctionDetailsPage(documentId: args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found! LoL'),
        ),
      );
    });
  }

}