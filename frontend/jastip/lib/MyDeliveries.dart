// Mydeliveries.dart
import 'package:flutter/material.dart';
import 'package:jastip/descriptionPage.dart';
import 'ToggablePage.dart';
import 'GenericAuctionListing.dart';
import 'Constants.dart';
import 'BidPage.dart';
import 'ReviewPage.dart';
import 'SetAddress.dart';

class MyDeliveries extends ToggablePage {
  MyDeliveries({Key? key, int initialIndex = 0}) : super(key: key, initialIndex: initialIndex);

  @override
  MyDeliveriesState createState() => MyDeliveriesState();
}

class MyDeliveriesState extends ToggablePageState<MyDeliveries> {
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
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'ongoing'}, table: 'deliveryAuctions', listingDescription: (listing) => DescriptionPage(overlay: BidPageOverlay(listing: listing), listing: listing,),),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'inTransit'}, table: 'deliveryAuctions', listingDescription: (listing) => DescriptionPage(overlay: SetAddressOverlay(listing: listing,), listing: listing,),),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'completed'}, table: 'deliveryAuctions', listingDescription: (listing) => DescriptionPage(overlay: ReviewPageOverlay(listing: listing,), listing: listing,),),
        );
      default:
        return Container();
    }
  }
}
