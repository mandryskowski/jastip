import 'package:flutter/material.dart';
import 'package:jastip/FormBox.dart';
import "package:jastip/LoadingPage.dart";
import 'package:jastip/PageHeader.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Column(
        children: [
          PageHeader(title: 'JASTIP+'),
          Expanded(
            child: Formbox(fields: ["City", "City","City","City","City","City","City", "Name", "Date"]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoadingScreen()),
          );
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}