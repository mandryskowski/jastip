import 'package:flutter/material.dart';
import 'package:jastip/ReviewPage.dart';
import 'package:jastip/descriptionPage.dart';
import 'ToggablePage.dart';
import 'GenericAuctionListing.dart';
import 'Constants.dart';
import 'ConfirmDeletePage.dart';
import 'EditAuction.dart';
import 'DeliveryPage.dart';
import 'DescriptionPageCarrier.dart';
import 'Listing.dart';
import 'FormElement.dart';

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
            listingDescription: (listing) => DescriptionPage(overlays: [EditAucitonOverlay(listing: listing), ConfirmDeleteOverlay(listing: listing)], listing: listing,),
            ),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: GenericAuctionListing(
            initialRoute: '/Menu', 
            args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'inTransit'}, 
            table: 'deliveryAuctions', 
            listingDescription: (listing) => DescriptionPageCarrier(overlays: [ConfirmPackagePickup(listing: listing,)], listing: listing,),
            ),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
          child: GenericAuctionListing(initialRoute: '/Menu', args: {'userId': LoggedInUserData().userInfo.id.toString(), 'status': 'completed'}, table: 'deliveryAuctions', 
          listingDescription: (listing) => DescriptionPageCarrier(overlays: [ReviewPageOverlay(listing: listing)], listing: listing,),),
        );
      default:
        return Container();
    }
  }
}

class ConfirmPackagePickup extends StatefulWidget {
  final Listing listing;

  const ConfirmPackagePickup({required this.listing});

  @override
  _ConfirmPackagePickupState createState() => _ConfirmPackagePickupState();
}

class _ConfirmPackagePickupState extends State<ConfirmPackagePickup> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  bool _isLoading = false;

  void _confirmPickup() {
    setState(() {
      _isLoading = true;
    });
    //widget.onDeleteConfirmed();
    overlayPortalController.toggle();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black54,
            dismissible: true,
            onDismiss: overlayPortalController.toggle,
          ),
          Center(
            child: Material(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: backgroundColorData,
                width: MediaQuery.of(context).size.width * 0.75,
                child: _isLoading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing...'),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Are you sure you want to confirm package pickup?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubmitButton(
                                onPressed: overlayPortalController.toggle,
                                buttonText: 'Cancel',
                                minimumSize: Size(100, 48),
                              ),
                              SubmitButton(
                                onPressed: _confirmPickup,
                                buttonText: 'Confirm',
                                minimumSize: Size(100, 48),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
      child: SubmitButton(
        onPressed: overlayPortalController.toggle,
        buttonText: 'Confirm Pickup',
         minimumSize: Size(200, 48),
      ),
    );
  }
}