import 'package:flutter/material.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/LoadingPage.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({
    super.key,
    required this.listings,
  });

  final List<Listing> listings;
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: Column(
          children: [
            PageHeader(title: "JASTIP+"),
            Expanded(child:Container(
              color: const Color.fromARGB(255, 255, 255, 255), // Set background color as needed
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      listings.length, 
                      (index) => ListingWidget(listing: listings[index])
                    ),
                  ),
                ),
              ),
            ))
          ]
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