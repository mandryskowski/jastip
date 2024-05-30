import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import 'package:jastip/CarrierPage.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Constants.dart';
import 'ToggleButton.dart';

class DeliveryPage extends StatefulWidget {
  DeliveryPage({Key? key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
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

class DeliveryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Formbox(
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
                checkboxTitles: ["fragile?", "skibidi?", "toilet?"]);
  }
}

