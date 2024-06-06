import 'package:flutter/material.dart';
import 'package:jastip/BidPage.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/GenericAuctionListing.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingPage extends StatelessWidget {
  ListingPage({
    super.key,
    this.args = const <String, String>{},
    this.orderingIndex = 0,
    required this.initialRoute,
  });

  final Map<String, String> args;
  final int orderingIndex;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          BackPageHeader(
            title: 'JASTIP+',
            initialRoute: initialRoute,
          ),
          Expanded(
            child: GenericAuctionListing(
              args: args,
              initialRoute: initialRoute,
              table: 'auctions',
            ),
          ),
        ],
      ),
    );
  }
}
