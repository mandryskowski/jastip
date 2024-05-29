import 'package:flutter/material.dart';
import 'package:jastip/Listing.dart';
import 'package:jastip/ListingPage.dart';

class Formbox extends StatefulWidget {
  const Formbox({
    Key? key,
    required this.title,
    required this.fields,
    this.checkboxTitles = const [],
    this.constraints = const BoxConstraints(),
  }) : super(key: key);

  final String title;
  final List<String> fields;
  final List<String> checkboxTitles;
  final BoxConstraints constraints;

  @override
  _FormboxState createState() => _FormboxState();
}

class _FormboxState extends State<Formbox> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _checkboxValues = {};

  @override
  void initState() {
    super.initState();
    for (var title in widget.fields) {
      _controllers[title] = TextEditingController();
    }
    for (var title in widget.checkboxTitles) {
      _checkboxValues[title] = false;
    }
  }

  @override
  void dispose() {
     for (var entry in _controllers.entries) {
      entry.value.dispose();
    }
    super.dispose();
  }

  void _submit() {
    for (var entry in _controllers.entries) {
      print('${entry.key}: ${entry.value.text}');
    }
    for (var entry in _checkboxValues.entries) {
      print('${entry.key}: ${entry.value}');
    }
    try {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListingPage(
        orderedByDate: false,
        orderedBySize: false,
        startCity: _controllers['From']!.text,
        endCity: _controllers['To']!.text,
        endDate: DateTime.parse(_controllers['Date']!.text),
        dimensions: Dimension(
          height: int.parse(_controllers['Height']!.text),
          width: int.parse(_controllers['Width']!.text),
          length: int.parse(_controllers['Length']!.text),
        ),
      )),
    );
    // Add your submit logic here
    } catch(e) {
      print(e);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListingPage.generic()),
    );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Center( // Center the Formbox to apply margin
      child: ConstrainedBox(
        constraints: widget.constraints,
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
                    widget.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ...List.generate(
                  widget.fields.length,
                  (index) => SearchBarWidget(
                    text: widget.fields[index],
                    controller: _controllers[widget.fields[index]]!,
                  ),
                ),
                ...List.generate(
                  widget.checkboxTitles.length,
                  (index) => CheckboxWidget(
                    title: widget.checkboxTitles[index],
                    value: _checkboxValues[widget.checkboxTitles[index]]!,
                    onChanged: (bool? value) {
                      setState(() {
                        _checkboxValues[widget.checkboxTitles[index]] = value!;
                      });
                    },
                  ),
                ),
                SubmitButton(
                  onPressed: _submit,
                  buttonText: 'Submit', // Specify the text for the button
                ),
              ],
            ),
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
    required this.controller,
  }) : super(key: key);

  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Reduced vertical margin
      padding: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18, // Increased text size
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0), // Small spacing between text and search bar
          SearchBar(
            hintText: text,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const SearchBar({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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

class CheckboxWidget extends StatelessWidget {
  const CheckboxWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ],
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


