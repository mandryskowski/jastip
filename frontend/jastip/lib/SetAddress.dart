import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/MyDeliveries.dart';
import 'package:jastip/SimpleFormBox.dart';
import 'Listing.dart';
import 'Constants.dart';

class SetAddressOverlay extends StatefulWidget {
  final Listing listing;

  const SetAddressOverlay({super.key, required this.listing});

  @override
  SetAddressOverlayState createState() => SetAddressOverlayState();
}

class SetAddressOverlayState extends State<SetAddressOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  final TextEditingController reviewController = TextEditingController();

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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: SimpleFormBox(
                  fields: [
                    MapEntry('Full name', [
                      SearchBarContentsTuple('eg. John Bob Smith', String, 'name'),
                    ]),
                    MapEntry('Address Line 1', [
                      SearchBarContentsTuple('eg. Downing Street 3', String, 'line1'),
                    ]),
                    MapEntry('Address Line 2', [
                      SearchBarContentsTuple('eg. Room 7B', String, 'line2'),
                    ]),
                    MapEntry('City', [
                      SearchBarContentsTuple('eg. London', String, 'city'),
                    ]),
                    MapEntry('Postal Code', [
                      SearchBarContentsTuple('eg. SW1A 2AA', String, 'postal'),
                    ]),
                  ], 
                  action: 'Set address', 
                  submitAction: submitAction,
                ),
              ),
            ),
          ),
        ]
      ),
      child: SubmitButton(
        onPressed: overlayPortalController.toggle,
        buttonText: 'Set address',
        enabled: true,
      ),
    );
  }

  void submitAction(Map<String, String> mp, BuildContext context) {
    mp['auction_id'] = widget.listing.auctionId.toString();
    try {
     HttpRequests.postRequest(mp, 'address');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyDeliveries(initialIndex: 1,), settings: RouteSettings(name: '/MyDeliveries1')),
      );
    } catch (e) {
      // Handle any errors that occur during the POST request
      print('An error occurred: $e');
    }
  }
}
