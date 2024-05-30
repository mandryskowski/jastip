import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import 'package:jastip/DeliveryPage.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/ToggleButton.dart';

class CarrierPage extends StatefulWidget {
  CarrierPage({Key? key}) : super(key: key);

  @override
  _CarrierPageState createState() => _CarrierPageState();
}

class _CarrierPageState extends State<CarrierPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          PageHeader(title: 'JASTIP+'),
          ToggleButton(
            onToggle: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedIndex: _selectedIndex,
          ),
          Expanded(
            child: _selectedIndex == 0 ? DeliveryContent() : CarrierContent(),
          ),
        ],
      ),
    );
  }
}

class CarrierContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Formbox(
                title: "Trip details",
                fields: [
                  MapEntry('Destination', [
                    SearchBarContentsTuple('From', String, 'startCity'),
                    SearchBarContentsTuple('To', String, 'endCity')
                  ]),
                  MapEntry('Package timeline', [
                    SearchBarContentsTuple('Departure', String, 'departureDate'),
                    SearchBarContentsTuple('Arrival', String, 'arrivalDate')
                  ]),
                  MapEntry('Package dimensions', [
                    SearchBarContentsTuple('Length', int, 'length'),
                    SearchBarContentsTuple('Width', int, 'width'),
                    SearchBarContentsTuple('Height', int, 'height'),
                  ]),
                  MapEntry('Package weight', [
                    SearchBarContentsTuple('Weight', String, 'weight'),
                  ]),
                  MapEntry('Starting price', [
                    SearchBarContentsTuple('Price', String, 'startingPrice'),
                  ]),
                  MapEntry('Auction length', [
                    SearchBarContentsTuple('Days', String, 'auctionEnds'),
                  ]),
                  MapEntry('Additional information', [
                    SearchBarContentsTuple('', String, 'info'),
                  ]),
                ],
                constraints: BoxConstraints(
                    maxWidth: 0.9 * MediaQuery.sizeOf(context).width),
                checkboxTitles: ["fragile?", "skibidi?", "toilet?"]);
  }
}
