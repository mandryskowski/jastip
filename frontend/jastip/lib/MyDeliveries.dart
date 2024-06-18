// Mydeliveries.dart
import 'package:flutter/material.dart';
import 'package:jastip/descriptionPage.dart';
import 'ToggablePage.dart';
import 'GenericAuctionListing.dart';
import 'Constants.dart';
import 'BidPage.dart';
import 'ReviewPage.dart';
import 'SetAddress.dart';
import 'Listing.dart';

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
          child: GenericAuctionListing(
            initialRoute: '/Menu', 
            args: {'bidderId': LoggedInUserData().userInfo.id.toString(), 'status': 'ongoing'}, 
            table: 'deliveryAuctions', 
            listingDescription: (listing) => DescriptionPage(overlays: [BidPageOverlay(listing: listing)], listing: listing,),
            additionalListingInfo: ongoingListingInfo,),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: GenericAuctionListing(
            initialRoute: '/Menu', 
            args: {'bidderId': LoggedInUserData().userInfo.id.toString(), 'status': 'inTransit'}, 
            table: 'deliveryAuctions', 
            listingDescription: (listing) => DescriptionPage(overlays: [SetAddressOverlay(listing: listing, title: 'Set pickup'), SetAddressOverlay(listing: listing, title: 'Set dropoff')], listing: listing,),
            additionalListingInfo: inTransitListingInfo,),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'bidderId': LoggedInUserData().userInfo.id.toString(), 'status': 'completed'}, table: 'deliveryAuctions', listingDescription: (listing) => DescriptionPage(overlays: [ReviewPageOverlay(listing: listing,)], listing: listing,),),
        );
      default:
        return Container();
    }
  }

  Widget? inTransitListingInfo(Listing listing) {
    //print('${listing.auctionWinner.id != LoggedInUserData().userInfo.id} xd\n');
    if (listing.address == null)
    {
        return Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.yellow,
          child: const Row(
            children: [
              Icon(Icons.warning, color: Colors.black),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Warning: You haven\' set destination address for this package.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
    }
    else
    {
      return null;
    }
  }

  Widget? ongoingListingInfo(Listing listing) {
    //print('${listing.auctionWinner.id != LoggedInUserData().userInfo.id} xd\n');
    if (listing.auctionWinner.id != LoggedInUserData().userInfo.id)
    {
        return Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.yellow,
          child: const Row(
            children: [
              Icon(Icons.warning, color: Colors.black),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Warning: Your bid has been surpassed. Place a new bid to stay in the auction.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
    }
    else
    {
      return null;
    }
  }
}
