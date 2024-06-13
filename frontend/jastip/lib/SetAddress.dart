import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/MyDeliveries.dart';
import 'package:jastip/SimpleFormBox.dart';
import 'Listing.dart';
import 'Constants.dart';

class SetAddressOverlay extends StatefulWidget {
  final Listing listing;
  final String title;

  const SetAddressOverlay({super.key, required this.listing, required this.title});

  @override
  SetAddressOverlayState createState() => SetAddressOverlayState();
}

class SetAddressOverlayState extends State<SetAddressOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  final TextEditingController reviewController = TextEditingController();

  OverlayEntry? overlayEntry;

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry?.remove();
        },
        child: Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {},
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubmitButton(
      onPressed: () {
        overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(overlayEntry!);
      },
      buttonText: widget.title,
      enabled: true,
      minimumSize: const Size(150, 48),
    );
  }

  void submitAction(Map<String, String> mp, BuildContext context) {
    mp['auction_id'] = widget.listing.auctionId.toString();
    try {
      HttpRequests.postRequest(mp, 'address');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyDeliveries(
            initialIndex: 1,
          ),
          settings: RouteSettings(name: '/MyDeliveries1'),
        ),
      );
      overlayEntry?.remove();
    } catch (e) {
      // Handle any errors that occur during the POST request
      print('An error occurred: $e');
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }
}
