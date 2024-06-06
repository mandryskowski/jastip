// Mydeliveries.dart
import 'package:flutter/material.dart';
import 'ToggablePage.dart';
import 'Listing.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jastip/BidPage.dart';

class Mydeliveries extends ToggablePage {
  Mydeliveries({Key? key, int initialIndex = 0}) : super(key: key, initialIndex: initialIndex);

  @override
  _MydeliveriesState createState() => _MydeliveriesState();
}

class _MydeliveriesState extends ToggablePageState<Mydeliveries> {
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
          child: MyDeliveriesOngoing.generic('/MyDeliveries0'),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: NewContent(),
        );
      case 2:
        return Container(
          key: ValueKey<int>(2),
          child: NewContent(),
        );
      default:
        return Container();
    }
  }
}

class NewContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('New Content', style: TextStyle(fontSize: 24)),
    );
  }
}

class MyDeliveriesOngoing extends StatelessWidget {
  MyDeliveriesOngoing({super.key, required this.args, this.orderingIndex = 0, required this.initialRoute});

  static MyDeliveriesOngoing generic(String currentRoute) {
    return MyDeliveriesOngoing(args: const {}, initialRoute: currentRoute);
  }

  final Map<String, String> args;
  int orderingIndex;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          List<Listing> listings = snapshot.data!;
          return Column(
              children: [
                Orderingbar(args: args, orderIndex: orderingIndex, initialRoute: initialRoute),
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
                            (index) => ListingWidget(listing: listings[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
        } else {
          return Container(); // Handle the case when there is no data
        }
      },
    );
  }

  Future<List<Listing>> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://jastip-backend-3b036fb5403c.herokuapp.com/auctions${getParameters()}"));
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
    for (var entry in args.entries)
      if (entry.value.isNotEmpty) {
        sb.write("${entry.key}=${entry.value.toString()}&");
      }
    return sb.toString();
  }
}

class ListingWidget extends StatelessWidget {
  const ListingWidget({
    super.key,
    required this.listing,
  });

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => BidPage(listing: listing)));
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration:
            BoxDecoration(border: Border.all(color: const Color(0xFFDA2222))),
        child: _listingChild(),
      ));
  }

  Row _listingChild() {
    return Row(
          children: [
            Expanded(child:Column(
              children: [
        Align(
            alignment: Alignment(-1.0, -0.5),
            child: Text("${listing.source} (${listing.departureDate.toString().split(" ")[0]})")),
        Align(
            alignment: Alignment(-1.0, 0.0),
            child: Text("->")),
        Align(
            alignment: const Alignment(-1.0, 0.5),
            child: Text("${listing.destination} (${listing.arrivalDate.toString().split(" ")[0]})")),
          ])),
          Expanded(child:Column(children: [Align(
            alignment: Alignment(1.0, -1.0),
            child: Text("Current bid: \$${listing.price}")),
        Align(
            alignment: Alignment(1.0, 0.5),
            child: Text("Size: ${listing.dimensions}")),
        Align(
            alignment: Alignment(1.0, 1.0),
            child: Text("End: ${listing.auctionEnd.toString().split(" ")[0]} ${listing.auctionEnd.toString().split(" ")[1].split('.')[0]} UTC"))
          ]))]
      );
  }
}