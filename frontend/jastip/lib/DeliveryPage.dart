import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import 'FormElement.dart';


class DeliveryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Formbox(
      title: "Where do we go today?",
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
      checkboxTitles: ["fragile"]),);
  }
}

