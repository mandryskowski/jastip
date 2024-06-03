import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jastip/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SearchBarJastip extends StatefulWidget {
  final SearchBarContentsTuple hint;
  final TextEditingController controller;

  const SearchBarJastip({
    Key? key,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  _SearchBarJastipState createState() => _SearchBarJastipState();
}

class _SearchBarJastipState extends State<SearchBarJastip> {
  List<String> _hints = [];

  @override
  Widget build(BuildContext context) {
    switch (widget.hint.type) {
      case DateTime:
        return DateSearchBar(hintText: widget.hint.content, controller: widget.controller);
      case int:
        return NumberSearchBar(hint: widget.hint, controller: widget.controller);
      default:
        return Column(
          children: [
            TextField(
              controller: widget.controller,
              onChanged: widget.hint.searchable ? (value) => onChangedSearch(value, widget.hint.dbQueryParam) : null,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
              decoration: InputDecoration(
                hintText: widget.hint.content,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            if (_hints.isNotEmpty)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _hints.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_hints[index]),
                      onTap: () {
                        widget.controller.text = _hints[index];
                        setState(() {
                          _hints.clear();
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        );
    }
  }

  void onChangedSearch(String content, String column) async {
    if (content.isEmpty) {
      setState(() {
        _hints = [];
      });
      return;
    }

    final url = Uri.parse('https://jastip-backend-3b036fb5403c.herokuapp.com/suggestions?column=$column&$column=$content');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _hints = data.map((item) => item.toString()).take(3).toList();
      });
    } else {
      // Handle error
      setState(() {
        _hints = [];
      });
    }
  }
}

class NumberSearchBar extends StatelessWidget {
  final SearchBarContentsTuple hint;
  final TextEditingController controller;

  const NumberSearchBar({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(regExpFormatter[hint.type] as Pattern)
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint.content,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: backgroundColor,
      ),
    );
  }
}

class SearchBarContentsTuple {
  String content;
  Type type;
  String dbQueryParam;
  bool searchable;

  SearchBarContentsTuple(this.content, this.type, this.dbQueryParam, {this.searchable = false});
}

class DateSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const DateSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  _DateSearchBarState createState() => _DateSearchBarState();
}

class _DateSearchBarState extends State<DateSearchBar> {
  final _dateFormatRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // YYYY-MM-DD format
  
  _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        widget.controller.text = "${"${selectedDate.toLocal()}".split(' ')[0]} 12:00:00";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  bool _isValidDate(String input) {
    return input == '' || _dateFormatRegex.hasMatch(input);
  }
}

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll15,
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
                return primaryColorDark;
              }
              // Default color
              return primaryColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                // Text color when pressed
                return backgroundColorData;
              }
              // Default text color
              return backgroundColor;
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
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(200, 48), // Adjust the width and height as needed
          ),
        ),
        child: Text(
          widget.buttonText,
          style: const TextStyle(fontSize: 18)
        ),
        
      ),
    );
  }
}