import 'package:flutter/material.dart';
import 'package:jastip/LoadingPage.dart';
import 'package:jastip/PageHeader.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BackPageHeader(title: 'JASTIP+'),
          Expanded(
            child: Text("This is a filter page")
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoadingScreen(), settings: RouteSettings(name: "/LoadingScreen"))
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}