import 'package:flutter/material.dart';
import 'package:jastip/OrderingBar.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingPage extends StatelessWidget {
  const ListingPage({
    super.key,
    required this.orderedBySize,
    required this.orderedByDate,
  });

  final bool orderedBySize;
  final bool orderedByDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          List<Listing> listings = snapshot.data!;
          return Scaffold(
            body: Column(
              children: [
                PageHeader(title: "JASTIP+"),
                Orderingbar(),
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
                  MaterialPageRoute(builder: (context) => const LoadingScreen()),
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
  
  Future<List<Listing>> fetchData() async{
    final response = await http.get(Uri.parse('https://jastip-backend-3b036fb5403c.herokuapp.com/bids-json'));
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body);
      return List<Listing>.from(list.map((listing) => Listing.fromJson(listing)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
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
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDA2222))
      ),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child:Text("${listing.source} -> ${listing.destination}")),
          Align(alignment: Alignment.centerRight, child:Text(listing.dimensions.toString())),
          Align(alignment: Alignment.bottomRight, child:Text(listing.dateTime.toString())),
        ]
      ),
    );

  }
}