import 'package:flutter/material.dart';
import 'package:jastip/ToggleButton.dart';
import 'Constants.dart';
import 'PageHeader.dart';
import 'menu.dart';

abstract class ToggablePage extends StatefulWidget {
  final int initialIndex;

  ToggablePage({Key? key, this.initialIndex = 0}) : super(key: key);
}

abstract class ToggablePageState<T extends ToggablePage> extends State<T> {
  late int _selectedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

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
              titles: getTitles(),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final slideAnimation = Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset(0, 0),
                ).animate(animation);

                return SlideTransition(position: slideAnimation, child: child);
              },
              child: getPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  List<String> getTitles();

  Widget getPage(int index);
}
