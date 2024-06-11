import 'package:flutter/material.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';
import 'MyDeliveries.dart';

class BidPageOverlay extends StatefulWidget {
  final Listing listing;

  const BidPageOverlay({required this.listing});

  @override
  _BidPageOverlayState createState() => _BidPageOverlayState();
}

class _BidPageOverlayState extends State<BidPageOverlay> {
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  final TextEditingController _bidController = TextEditingController();
  String _selectedPaymentMethod = 'Visa-6896';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bidController.addListener(_onBidAmountChanged);
  }

  @override
  void dispose() {
    _bidController.removeListener(_onBidAmountChanged);
    _bidController.dispose();
    super.dispose();
  }

  void _onBidAmountChanged() {
    setState(() {});
  }

  void _placeBid() async {
    setState(() {
      _isLoading = true;
    });

    final bidAmount = double.tryParse(_bidController.text);
    final currentBid = widget.listing.getCurrentBid();
    if (bidAmount != null && bidAmount > currentBid) {
      Map<String, String> args = {'auctionId': widget.listing.auctionId.toString(), 
                                  'price': bidAmount.toString(),
                                  'userId': LoggedInUserData().userInfo.id.toString()};
      await HttpRequests.postRequest(args, 'bids');
      print('Bid placed: $bidAmount with $_selectedPaymentMethod');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyDeliveries(), settings: RouteSettings(name: '/MyDeliveries0')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _canBid() {
    final bidAmount = double.tryParse(_bidController.text);
    print('$bidAmount and previous ${widget.listing.getCurrentBid()} and can ${bidAmount != null && bidAmount > widget.listing.getCurrentBid()}');

    return bidAmount != null && bidAmount > widget.listing.getCurrentBid();
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
              width: MediaQuery.of(context).size.width * 0.75, // Adjust width here
              child: _isLoading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Placing your bid...'),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _bidController,
                          decoration: InputDecoration(
                            labelText: 'Bid Amount (GBP)',
                            hintText: 'eg. 29.54',
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onSubmitted: (value) {
                            final bidAmount = double.tryParse(value);
                            if (bidAmount == null || bidAmount <= widget.listing.getCurrentBid()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Bid amount must be higher than ${widget.listing.getCurrentBid()} GBP'),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        _CustomDropdownButton(
                          value: 'Visa-6896',
                          items: ['Visa-6896', 'MasterCard-1234'],
                          onChanged: (newValue) {
                            _selectedPaymentMethod = newValue!;
                          },
                        ),
                        SizedBox(height: 16),
                        SubmitButton(
                          onPressed: _placeBid,
                          buttonText: 'Place bid',
                          enabled: _canBid(),
                          disabledTitle: 'Bid too low',
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
        buttonText: 'Bid',
      ),
    );
  }
}

class _CustomDropdownButton extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _CustomDropdownButton({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<_CustomDropdownButton> {
  late String _selectedValue;
  final OverlayPortalController overlayPortalController = OverlayPortalController();
  Size? _buttonSize;
  Offset? _buttonOffset;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateButtonDimensions();
    });
  }

  void _updateButtonDimensions() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _buttonSize = size;
      _buttonOffset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: overlayPortalController.toggle,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: _buttonOffset!.dx,
            top: _buttonOffset!.dy + _buttonSize!.height,
            width: _buttonSize!.width,
            child: Material(
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.map((String value) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedValue = value;
                      });
                      widget.onChanged(value);
                      overlayPortalController.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: overlayPortalController.toggle,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Payment method',
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedValue),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
