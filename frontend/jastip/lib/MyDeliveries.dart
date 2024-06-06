// Mydeliveries.dart
import 'package:flutter/material.dart';
import 'ToggablePage.dart';
import 'Listing.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jastip/BidPage.dart';
import 'GenericAuctionListing.dart';

class Mydeliveries extends ToggablePage {
  Mydeliveries({Key? key, int initialIndex = 0}) : super(key: key, initialIndex: initialIndex);

  @override
  _MydeliveriesState createState() => _MydeliveriesState();
}

class _MydeliveriesState extends ToggablePageState<Mydeliveries> {
  @override
  List<String> getTitles() {
    return ['ongoing', 'in transit', 'completed'];
  }

  @override
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Container(
          key: ValueKey<int>(0),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': '4', 'status': 'ongoing'}, table: 'deliveryAuctions'),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': '4', 'status': 'inTransit'}, table: 'deliveryAuctions'),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': '4', 'status': 'completed'}, table: 'deliveryAuctions'),
        );
      default:
        return Container();
    }
  }
}

class NewContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('New Content', style: TextStyle(fontSize: 24)),
    );
  }
}