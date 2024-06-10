import 'package:flutter/material.dart';
import 'package:jastip/BidPage.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'descriptionPage.dart';

class GenericAuctionListing extends StatefulWidget {
  GenericAuctionListing({super.key, required this.args, this.orderingIndex = 0, required this.initialRoute, required this.table, required this.listingDescription, this.additionalListingInfo});

  final Map<String, String> args;
  int orderingIndex;
  final String initialRoute;
  final String table;
  final Widget Function(Listing) listingDescription;
  final Widget? Function(Listing)? additionalListingInfo;

  @override
  _GenericAuctionListingState createState() => _GenericAuctionListingState();
}

class _GenericAuctionListingState extends State<GenericAuctionListing> {
  late Future<List<Listing>> _futureListings;

  @override
  void initState() {
    super.initState();
    _futureListings = fetchData();
  }

  Future<List<Listing>> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://jastip-backend-3b036fb5403c.herokuapp.com/${widget.table}${getParameters()}"));
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body);
      return List<Listing>.from(
          list.map((listing) => Listing.fromJson(listing)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  String getParameters() {
    StringBuffer sb = StringBuffer();
    sb.write("?");
    for (var entry in widget.args.entries)
      if (entry.value.isNotEmpty) {
        sb.write("${entry.key}=${entry.value.toString()}&");
      }
    return sb.toString();
  }

  void _onOrderChanged() {
    setState(() {
      widget.orderingIndex = (widget.orderingIndex + 1) % orderings.length;
      widget.args['orderedBy'] = orderings[widget.orderingIndex].toLowerCase();
      _futureListings = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: _futureListings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            children: [
              ModalBarrier(
                color: Colors.black.withOpacity(0.3),
                dismissible: false,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading auctions...',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          List<Listing> listings = snapshot.data!;
          return Container(
            child: Column(
              children: [
                Orderingbar(
                  args: widget.args,
                  orderIndex: widget.orderingIndex,
                  initialRoute: widget.initialRoute,
                  onOrderChanged: _onOrderChanged,
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            listings.length,
                            (index) => ListingWidget(
                              listing: listings[index],
                              listingDescription: widget.listingDescription,
                              additionalListingInfo: widget.additionalListingInfo,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(); // Handle the case when there is no data
        }
      },
    );
  }
}

class ListingWidget extends StatelessWidget {
  const ListingWidget({
    super.key,
    required this.listing,
    required this.listingDescription,
    this.additionalListingInfo
  });

  final Listing listing;
  final Widget Function(Listing) listingDescription;
  final Widget? Function(Listing)? additionalListingInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => listingDescription(listing)));
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDA2222)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (additionalListingInfo != null)
              additionalListingInfo!(listing) ?? Container(),
            _listingChild(),
          ],
        ),
      ),
    );
  }

  Row _listingChild() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment(-1.0, -0.5),
                child: Text("${listing.source} (${listing.departureDate.toString().split(" ")[0]})"),
              ),
              Align(
                alignment: Alignment(-1.0, 0.0),
                child: Text("->"),
              ),
              Align(
                alignment: const Alignment(-1.0, 0.5),
                child: Text("${listing.destination} (${listing.arrivalDate.toString().split(" ")[0]})"),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment(1.0, -1.0),
                child: Text("Current bid: \$${listing.getCurrentBid()}"),
              ),
              Align(
                alignment: Alignment(1.0, 0.5),
                child: Text("Size: ${listing.dimensions}"),
              ),
              Align(
                alignment: Alignment(1.0, 1.0),
                child: Text("End: ${listing.auctionEnd.toString().split(" ")[0]} ${listing.auctionEnd.toString().split(" ")[1].split('.')[0]} UTC"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

