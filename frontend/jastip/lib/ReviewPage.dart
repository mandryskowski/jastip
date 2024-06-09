import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/FormElement.dart';
import 'Listing.dart';
import 'MyDeliveries.dart';

class ReviewPageOverlay extends StatefulWidget {
  final Listing listing;

  const ReviewPageOverlay({super.key, required this.listing});

  @override
  _ReviewPageOverlayState createState() => _ReviewPageOverlayState();
}

class _ReviewPageOverlayState extends State<ReviewPageOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  final TextEditingController reviewController = TextEditingController();
  int _currentRating = 0;

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
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentRating = index + 1;
                            });
                          },
                          child: Icon(
                            Icons.star,
                            color: index < _currentRating ? Colors.yellow : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    Text('Review:', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    TextField(
                      controller: reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    SubmitButton(
                      onPressed: _submit,
                      buttonText: 'Submit review',
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: SubmitButton(
        onPressed: overlayPortalController.toggle,
        buttonText: 'Review',
        enabled: true,
      ),
    );
  }

  void _submit() {
    final Map<String, String> mp = {
      'auctionId': widget.listing.auctionId.toString(),
      'author': LoggedInUserData().userInfo.id.toString(),
      'about': widget.listing.userInfo.id.toString(),
      'rating': _currentRating.toString(),
      'content': reviewController.text,
    };

    HttpRequests.postRequest(mp, 'reviews');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyDeliveries(initialIndex: 2), settings: RouteSettings(name: '/MyDeliveries2')),
    );
  }
}
