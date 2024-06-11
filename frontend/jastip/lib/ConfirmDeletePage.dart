import 'package:flutter/material.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';

class ConfirmDeleteOverlay extends StatefulWidget {
  final Listing listing;

  const ConfirmDeleteOverlay({required this.listing});

  @override
  _ConfirmDeleteOverlayState createState() => _ConfirmDeleteOverlayState();
}

class _ConfirmDeleteOverlayState extends State<ConfirmDeleteOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  bool _isLoading = false;

  void _confirmDelete() {
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
                            'Are you sure you want to delete this auction?',
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
                                onPressed: _confirmDelete,
                                buttonText: 'Delete',
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
        buttonText: 'Delete Auction',
         minimumSize: Size(150, 48),
      ),
    );
  }
}