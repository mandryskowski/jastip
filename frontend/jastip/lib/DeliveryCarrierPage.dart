import 'package:flutter/material.dart';
import 'ToggablePage.dart';
import 'DeliveryPage.dart';
import 'CarrierPage.dart';

class HomePage extends ToggablePage {
  HomePage({int initialIndex = 0, Key? key}) : super(key: key, initialIndex: initialIndex);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ToggablePageState<HomePage> {
  @override
  List<String> getTitles() {
    return ['Delivery', 'Carrier'];
  }

  @override
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Container(
          key: ValueKey<int>(0),
          child: DeliveryContent(),
        );
      case 1:
        return Container(
          key: ValueKey<int>(1),
          child: CarrierContent(),
        );
      default:
        return Container();
    }
  }
}