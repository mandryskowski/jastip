import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jastip/Constants.dart';

class SearchBarJastip extends StatelessWidget {
  final SearchBarContentsTuple hint;
  final TextEditingController controller;

  const SearchBarJastip({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (hint.type) {
      case DateTime:
        return DateSearchBar(hintText: hint.content, controller: controller);
      case int:
        return NumberSearchBar(hint: hint, controller: controller);
      default:
        return TextField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.allow(regExpFormatter[hint.type] as Pattern)
          ],
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

  SearchBarContentsTuple(this.content, this.type, this.dbQueryParam);
}

class DateSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const DateSearchBar({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

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