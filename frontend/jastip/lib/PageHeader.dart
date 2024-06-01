import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: const Color(0xFFDA2222),
      child: Row(
        children: [
          Icon(
            Icons.menu,
            color: Colors.white,
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
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: const Color(0xFFDA2222),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuPressed,
            child: Icon(
              Icons.menu,
              color: Colors.white,
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
