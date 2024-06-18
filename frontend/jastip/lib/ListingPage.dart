import 'package:flutter/material.dart';
import 'package:jastip/BidPage.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/GenericAuctionListing.dart';
import 'package:jastip/PageHeader.dart';
import 'descriptionPage.dart';

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
              listingDescription:  (listing) => DescriptionPage(overlays: [BidPageOverlay(listing: listing)], listing: listing,),
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
