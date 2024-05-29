import 'package:flutter/material.dart';

class Formbox extends StatelessWidget {
  const Formbox({
    super.key,
    required this.fields,
  });

  final List<String> fields;
  @override
  Widget build(BuildContext context) {

      return Container(
        color: const Color.fromARGB(255, 255, 255, 255), // Set background color as needed
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                fields.length, 
                (index) => SearchBarWidget(text: fields[index])
              ),
            ),
          ),
        ),
      );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child:Text(text)),
          Center(child: SearchBar(hintText: text))
        ]
      ),
    );

  }
}