import 'package:flutter/material.dart';
import 'package:jastip/DeliveryPage.dart';
import 'package:jastip/CarrierPage.dart';
import 'package:jastip/ToggleButton.dart';
import 'Constants.dart';
import 'PageHeader.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const PageHeader(title: 'JASTIP+'),
          Padding(
            padding: paddingVertical10,
            child: ToggleButton(
              onToggle: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final slideAnimation = Tween<Offset>(
                  begin: _selectedIndex == 0 ? Offset(1, 0) : Offset(-1, 0),
                  end: Offset(0, 0),
                ).animate(animation);

                return SlideTransition(position: slideAnimation, child: child);
              },
              child: _selectedIndex == 0 
                ? Container(
                    key: ValueKey<int>(0),
                    child: DeliveryContent(),
                  )
                : Container(
                    key: ValueKey<int>(1),
                    child: CarrierContent(),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
