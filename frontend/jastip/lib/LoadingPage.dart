import 'package:flutter/material.dart';
import "package:jastip/BlankPage.dart";
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        // Navigate to the new page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BlankPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDA2222), // Hex color DA2222
      body: AnimatedOpacity(
        opacity: _timer.isActive ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'JASTIP+',
                style: GoogleFonts.caveat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adds some space between the two text widgets
              Text(
                'Connecting you to home',
                style: GoogleFonts.caveat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}