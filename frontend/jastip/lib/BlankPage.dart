import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import 'package:jastip/ListingPage.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Constants.dart';

class BlankPage extends StatelessWidget {
  BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          PageHeader(title: 'JASTIP+'),
          Expanded(
            //width: 300,
            child: Formbox(
                title: "Where to?",
                fields: [
                  MapEntry('Destination', [
                    SearchBarContentsTuple('From', String, 'startCity'),
                    SearchBarContentsTuple('To', String, 'endCity')
                  ]),
                  MapEntry('Date', [SearchBarContentsTuple('When', DateTime, 'endDate')]),
                  MapEntry('Dimensions', [
                    SearchBarContentsTuple('Length', int, 'length'),
                    SearchBarContentsTuple('Width', int, 'width'),
                    SearchBarContentsTuple('Height', int, 'height'),
                  ])
                ],
                constraints: BoxConstraints(
                    maxWidth: 0.9 * MediaQuery.sizeOf(context).width),
                checkboxTitles: ["fragile?", "skibidi?", "toilet?"]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListingPage.generic()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
