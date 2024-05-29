import 'package:flutter/material.dart';

class Formbox extends StatelessWidget {
  const Formbox({
    Key? key,
    required this.title,
    required this.fields,
    this.constraints = const BoxConstraints(),
  }) : super(key: key);

  final String title;
  final List<String> fields;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Container(
        color: const Color.fromRGBO(217, 217, 217, 100), // Set background color as needed
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...List.generate(
                fields.length,
                (index) => SearchBarWidget(text: fields[index]),
              ),
              SubmitButton(
                onPressed: () {
                  // Add your submit action here
                  print("Submit button pressed");
                },
                buttonText: 'Submit', // Specify the text for the button
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(text)),
          Center(
            child: SearchBar(
              hintText: text,
            ),
          )
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;

  const SearchBar({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12.0),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                // Darken color on press
                return const Color.fromARGB(255, 153, 23, 23);
              }
              // Default color
              return const Color.fromARGB(255, 218, 34, 34);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                // Text color when pressed
                return Colors.white;
              }
              // Default text color
              return Colors.white;
            },
          ),
          shadowColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                // Shadow color when pressed
                return Colors.black.withOpacity(0.8);
              }
              // Default shadow color
              return Colors.black.withOpacity(0.4);
            },
          ),
          elevation: WidgetStateProperty.all<double>(4), // Add elevation
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(0, 0),
          ),
        ),
        child: Text(widget.buttonText),
      ),
    );
  }
}


