import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/FilterPage.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/ListingPage.dart';

class Orderingbar extends StatelessWidget {
  Orderingbar({super.key, required this.args, required this.orderIndex});
  
  Map<String, String> args;
  int orderIndex;

  @override
  Widget build(BuildContext context) {
    String orderBy = "Ordered by: ${orderings[orderIndex]}";

    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    orderIndex = (orderIndex + 1) % orderings.length;
                    args['orderedBy'] = orderings[orderIndex].toLowerCase();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListingPage(args: args, orderingIndex: orderIndex)));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      color: const Color.fromARGB(255, 233, 140, 140),
                      child: Row(children: [
                        const Icon(
                          Icons.sort_by_alpha,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Center(
                            child: Text(
                          orderBy,
                          style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                      ])))),
          Container(
            width: 2.0, // Width of the separator
            color: const Color.fromARGB(
                255, 212, 20, 20), // Color of the separator
          ),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FilterPage()));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      color: const Color.fromARGB(255, 233, 140, 140),
                      child: Row(children: [
                        const Icon(
                          Icons.filter,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Center(
                            child: Text(
                          "Filter",
                          style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                      ])))),
        ],
      ),
    );
  }
}
