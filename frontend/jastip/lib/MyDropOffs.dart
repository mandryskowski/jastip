import 'package:flutter/material.dart';
import 'package:jastip/descriptionPage.dart';
import 'ToggablePage.dart';
import 'GenericAuctionListing.dart';
import 'Constants.dart';
import 'ConfirmDeletePage.dart';
import 'ReviewPage.dart';
import 'Listing.dart';

class MyDropoffs extends ToggablePage {
  MyDropoffs({Key? key, int initialIndex = 0}) : super(key: key, initialIndex: initialIndex);

  @override
  MyDropoffsState createState() => MyDropoffsState();
}

class MyDropoffsState extends ToggablePageState<MyDropoffs> {
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
          child: GenericAuctionListing(
            initialRoute: '/Menu', 
            args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'ongoing'}, 
            table: 'deliveryAuctions', 
            listingDescription: (listing) => DescriptionPage(overlays: [ConfirmDeleteOverlay(listing: listing), ConfirmDeleteOverlay(listing: listing)], listing: listing,),
            ),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          // child: GenericAuctionListing(
          //   initialRoute: '/Menu', 
          //   args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'inTransit'}, 
          //   table: 'deliveryAuctions', 
          //   listingDescription: (listing) => DescriptionPage(overlay: CarrierActionsOverlay(listing: listing,), listing: listing,),
          //   ),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
         // child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'completed'}, table: 'deliveryAuctions', listingDescription: (listing) => DescriptionPage(overlay: ReviewPageOverlay(listing: listing,), listing: listing,),),
        );
      default:
        return Container();
    }
  }
}