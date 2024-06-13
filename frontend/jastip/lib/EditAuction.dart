import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/MyDeliveries.dart';
import 'package:jastip/MyDropOffs.dart';
import 'package:jastip/SimpleFormBox.dart';
import 'Listing.dart';
import 'Constants.dart';
import 'CarrierPage.dart';

class EditAucitonOverlay extends StatefulWidget {
  final Listing listing;

  const EditAucitonOverlay({super.key, required this.listing});

  @override
  EditAucitonOverlayState createState() => EditAucitonOverlayState();
}

class EditAucitonOverlayState extends State<EditAucitonOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  final TextEditingController reviewController = TextEditingController();

  OverlayEntry? overlayEntry;

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Builder(
          builder: (overlayContext) => GestureDetector(
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
                      bottom: MediaQuery.of(overlayContext).viewInsets.bottom + 16.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(overlayContext).size.width * 0.9,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        child: SimpleFormBox(
                          title: "Trip details",
                          fields: [
                            MapEntry('Destination', [
                              SearchBarContentsTuple('From', String, 'from', initContent: widget.listing.source),
                              SearchBarContentsTuple('To', String, 'to', initContent: widget.listing.destination)
                            ]),
                            MapEntry('Package timeline', [
                              SearchBarContentsTuple('Departure', DateTime, 'departure', initContent: widget.listing.departureDate.toString()),
                              SearchBarContentsTuple('Arrival', DateTime, 'arrival', initContent: widget.listing.arrivalDate.toString())
                            ]),
                            MapEntry('Package dimensions', [
                              SearchBarContentsTuple('Length', int, 'length', initContent: widget.listing.dimensions.length.toString()),
                              SearchBarContentsTuple('Width', int, 'width', initContent: widget.listing.dimensions.width.toString()),
                              SearchBarContentsTuple('Height', int, 'height', initContent: widget.listing.dimensions.height.toString()),
                            ]),
                            MapEntry('Package weight', [
                              SearchBarContentsTuple('Weight', int, 'weight', initContent: widget.listing.weight.toString()),
                            ]),
                            MapEntry('Starting price', [
                              SearchBarContentsTuple('Price', int, 'startingPrice', initContent: widget.listing.price.toString()),
                            ]),
                            MapEntry('Auction length', [
                              SearchBarContentsTuple('Days', int, 'daysBefore', initContent: widget.listing.weight.toString()),
                            ]),
                            MapEntry('Additional information', [
                              SearchBarContentsTuple('Text', String, 'description', initContent: widget.listing.description),
                            ]),
                          ],
                          constraints: BoxConstraints(
                              maxWidth: 0.9 * MediaQuery.sizeOf(context).width),
                          checkboxTitles: ["fragile"],
                          action: 'Confirm changes',
                          submitAction: submitAction,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubmitButton(
      onPressed: () {
        overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(overlayEntry!);
      },
      buttonText: 'Edit details',
      minimumSize: const Size(150, 48),
      disabledTitle: 'Cannot edit',
      enabled: widget.listing.bidCnt == 0,
    );
  }

  void submitAction(Map<String, String> mp, BuildContext context) {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyDropoffs(initialIndex: 0),
          settings: RouteSettings(name: '/MyDropoffs0'),
        ),
      );
      overlayEntry?.remove();
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void removeOverlayTemporarily() {
    overlayEntry?.remove();
  }

  void reinsertOverlay() {
    if (overlayEntry != null) {
      Overlay.of(context)?.insert(overlayEntry!);
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    //overlayEntry?.remove();
    super.dispose();
  }
}


