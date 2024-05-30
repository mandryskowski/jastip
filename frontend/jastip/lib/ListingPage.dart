import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingPage extends StatelessWidget {

  ListingPage({super.key, required this.args, this.orderingIndex = 0});

  static ListingPage generic() {
    return ListingPage(args: {});
  }

  final Map<String, String> args;
  int orderingIndex;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          List<Listing> listings = snapshot.data!;
          return Scaffold(
            body: Column(
              children: [
                PageHeader(title: "JASTIP+"),
                Orderingbar(args: args, orderIndex: orderingIndex,),
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingScreen()),
                );
              },
              child: const Icon(Icons.refresh),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else {
          return Scaffold(); // Handle the case when there is no data
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
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xFFDA2222))),
      child: _listingChild(),
    );
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
