import 'package:flutter/material.dart';
import 'package:jastip/DeliveryPage.dart';
import 'package:jastip/CarrierPage.dart';
import 'package:jastip/ToggleButton.dart';
import 'Constants.dart';
import 'PageHeader.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  final int initialIndex; // Add initialIndex parameter

  HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(initialIndex); // Pass initialIndex
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _HomePageState(this._selectedIndex); // Receive initialIndex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: MenuBox(),
      body: Column(
        children: [
          MenuPageHeader(
            title: 'JASTIP+',
            onMenuPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
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


