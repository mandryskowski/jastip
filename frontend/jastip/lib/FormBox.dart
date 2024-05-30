import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/ListingPage.dart';

class Formbox extends StatefulWidget {
  const Formbox({
    super.key,
    required this.title,
    required this.fields,
    this.checkboxTitles = const [],
    this.constraints = const BoxConstraints(),
  });

  final String title;
  final List<MapEntry<String, List<SearchBarContentsTuple>>> fields;
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
    for (var group in widget.fields) {
      for (var field in group.value) {
        _controllers[field.content] = TextEditingController();
      }
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
    Map<String, String> mp = {};
    for (var entry in _controllers.entries) {
      print('${entry.key}: ${entry.value.text}');
      mp[entry.key] = entry.value.text;
    }
    for (var entry in _checkboxValues.entries) {
      print('${entry.key}: ${entry.value}');
      mp[entry.key] = entry.value.toString();
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListingPage(args: mp)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: widget.constraints,
        child: Container(
          color: backgroundColorData,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: paddingAll15,
                  child: Text(
                    widget.title,
                    style: titleTextStyle,
                  ),
                ),
                ...widget.fields.map((group) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.key,
                          style: fieldTitleTextStyle,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: group.value.map((field) {
                            return Expanded(
                              child: Padding(
                                padding: paddingHorizontal5,
                                child: SearchBar(
                                  hint: field,
                                  controller: _controllers[field.content]!,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
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
                  buttonText: 'Submit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final SearchBarContentsTuple hint;
  final TextEditingController controller;

  const SearchBar({
    Key? key,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class SearchBarContentsTuple {
  String content;
  Type type;

  SearchBarContentsTuple(this.content, this.type);
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
            style: searchBarTextStyle,
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
                return pimaryColorDark;
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
        ),
        child: Text(widget.buttonText),
      ),
    );
  }
}
