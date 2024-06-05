import 'package:flutter/material.dart';
import 'package:jastip/FormElement.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';
import 'DeliveryCarrierPage.dart';

class BidPage extends StatefulWidget {
  final Listing listing;

  const BidPage({super.key, required this.listing});

  @override
  _BidPageState createState() => _BidPageState();
}

class _BidPageState extends State<BidPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _bidController = TextEditingController();
  String _selectedPaymentMethod = 'Visa-6896';
  OverlayEntry? _overlayEntry;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _bidController.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _placeBid() {
      final bidAmount = double.tryParse(_bidController.text);
      final currentBid = widget.listing.getCurrentBid();
      if (bidAmount != null && bidAmount > currentBid) {
        Map<String, String> args = {'auctionId': widget.listing.auctionId.toString(), 
                                    'price': bidAmount.toString(),
                                    'userId': widget.listing.userInfo.userId.toString()};
        HttpRequests.postRequest(args, 'bids');
        print('Bid placed: $bidAmount with $_selectedPaymentMethod');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(), settings: RouteSettings(name: '/HomePage0')),
        );
        //_removeOverlay();
      } 
  }

OverlayEntry _createOverlayEntry() {
  return OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () => _removeOverlay(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black54, // Dim the background to focus on overlay
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height, // Ensure the container is scrollable
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing the overlay when interacting with it
              child: Material(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: backgroundColorData,
                  width: MediaQuery.of(context).size.width * 0.75, // Adjust width here
                  child: SingleChildScrollView(
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
                                  content: Text('Bid amount must be higher than ${widget.listing.price} GBP'),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  bool _canBid() {
     final bidAmount = double.tryParse(_bidController.text);
     return bidAmount != null && bidAmount > widget.listing.getCurrentBid();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: backgroundColor,
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const BackPageHeader(
                title: 'JASTIP+',
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAvailableSpaceSection(),
                    SizedBox(height: 16),
                    _buildTripPlanSection(),
                    SizedBox(height: 16),
                    _buildNoteFromTravellerSection(),
                    SizedBox(height: 16),
                    _buildUserInfoSection(),
                    SizedBox(height: 16),
                    _buildBidSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}




  Widget _buildAvailableSpaceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColorData,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Available Space'),
          SizedBox(height: 8),
          _buildSpaceDetailRow('Weight:', '${widget.listing.weight} kg', Icons.scale),
          _buildSpaceDetailRow('Length:', '${widget.listing.dimensions.length} cm', Icons.straighten),
          _buildSpaceDetailRow('Width:', '${widget.listing.dimensions.width} cm', Icons.straighten),
          _buildSpaceDetailRow('Height:', '${widget.listing.dimensions.height} cm', Icons.straighten),
          _buildSpaceDetailRow('Fragile?', widget.listing.fragile ? 'Accepted' : 'Not accepted', Icons.heart_broken),
        ],
      ),
    );
  }

  Widget _buildSpaceDetailRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTripPlanSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Trip Plan'),
          _buildTripPlanDetail('Mon 9th May', '01:45 (UTC+8)', 'Takeoff from CGK airport'),
          _buildTripPlanDetail('Mon 9th May', '12:25 (UTC+0)', 'Landing at LHR airport'),
          _buildTripPlanDetail('Fri 13th May', '21:00 (UTC+0)', 'Flyer sends parcel'),
          _buildTripPlanDetail('Mon 16th May - Wed 18th May', 'Any time', 'Royal Mail will deliver your parcel'),
        ],
      ),
    );
  }

  Widget _buildTripPlanDetail(String date, String time, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Center(
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColorDark,
              fontSize: 20,
            ),
          ),
        ),
        Divider(),
        Row(
          children: [
            Text(
              time,
              style: TextStyle(
                color: Color.fromARGB(200, 161, 83, 83),
                fontSize: 20,
              ),
            ),
            SizedBox(width: 20),
            Flexible( // Add Flexible to allow wrapping of description text
              child: Text(
                description,
                softWrap: true,
                style: TextStyle(fontSize: 20),
                maxLines: null,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildNoteFromTravellerSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColorData,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Note from traveller'),
          SizedBox(height: 14),
          Text(widget.listing.description, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.listing.userInfo.userProfileImage),
            radius: 50,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.listing.userInfo.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.green, size: 25),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.listing.userInfo.userRating}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 4,),
                  Text(
                    '(${widget.listing.userInfo.userReviewsCount} reviews)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bidSectionEntry('Current bid: ', '${widget.listing.getCurrentBid()}GBP'),
          _bidSectionEntry('Bids: ', '${widget.listing.bidCnt}'),
          _bidSectionEntry('Ends: ', '${widget.listing.auctionEnd}'),
          SizedBox(height: 16),
          Center(
            child: SubmitButton(
              onPressed: _showOverlay,
              buttonText: 'Bid',
            ),
          ),
        ],
      ),
    );
  }

  Widget _bidSectionEntry(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        decoration: TextDecoration.underline,
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
  OverlayEntry? _dropdownOverlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  void _showDropdown() {
    _dropdownOverlayEntry = _createDropdownOverlayEntry();
    Overlay.of(context).insert(_dropdownOverlayEntry!);
  }

  void _removeDropdown() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;
  }

  OverlayEntry _createDropdownOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
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
                  _removeDropdown();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDropdown,
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
    );
  }
}

