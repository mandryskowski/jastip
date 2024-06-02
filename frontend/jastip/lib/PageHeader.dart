import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Constants.dart';

class BackPageHeader extends StatelessWidget {
  final String title;
  final String initialRoute;

  const BackPageHeader({Key? key, required this.title, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 20, 16, 20),
      color: const Color(0xFFDA2222),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName(initialRoute));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.caveat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const MenuPageHeader({Key? key, required this.title, required this.onMenuPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 20, 16, 20),
      color: const Color(0xFFDA2222),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuPressed,
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.caveat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
