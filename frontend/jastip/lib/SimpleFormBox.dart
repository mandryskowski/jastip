import 'dart:convert';
import 'FormElement.dart';

import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/ListingPage.dart';
import 'package:http/http.dart' as http;

class SimpleFormBox extends StatefulWidget {
  const SimpleFormBox({
    super.key,
    this.title = '',
    required this.fields,
    this.checkboxTitles = const [],
    this.constraints = const BoxConstraints(),
    required this.action,
    required this.submitAction,
    this.suffix,
  });

  final String title;
  final List<MapEntry<String, List<SearchBarContentsTuple>>> fields;
  final List<String> checkboxTitles;
  final BoxConstraints constraints;
  final String action;
  final void Function(Map<String, String>, BuildContext) submitAction; 
  final Widget? suffix;

  @override
  _SimpleFormBoxState createState() => _SimpleFormBoxState();
}

class _SimpleFormBoxState extends State<SimpleFormBox> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _checkboxValues = {};

  @override
  void initState() {
    super.initState();
    for (var group in widget.fields) {
      for (var field in group.value) {
        final controller = TextEditingController();
        _controllers[field.dbQueryParam] = controller;
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

  String getParameters() {
    StringBuffer sb = StringBuffer();
    sb.write("?");
    for (var entry in _controllers.entries)
      if (entry.value.text != '') {
        sb.write("${entry.key}=${entry.value.text}&");
      }
    for (var entry in _checkboxValues.entries)
      if (entry.value.toString() != '') {
        sb.write("${entry.key}=${entry.value.toString()}&");
      }
    return sb.toString();
  }

  void _submit() {
    Map<String, String> mp = {};
    for (var entry in _controllers.entries) {
      mp[entry.key] = entry.value.text;
    }
    for (var entry in _checkboxValues.entries) {
      mp[entry.key] = entry.value.toString();
    }

    widget.submitAction(mp, context);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: widget.constraints,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColorData,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != '')
              ...{
                Padding(
                  padding: paddingAll15,
                  child: Text(
                    widget.title,
                    style: titleTextStyle,
                  ),
                ),
              },
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
                              child: SearchBarJastip(
                                hint: field,
                                controller: _controllers[field.dbQueryParam]!,
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
              Center(
                child: SubmitButton(
                  onPressed: _submit,
                  buttonText: widget.action,
                  enabled: true,
                ),
              ),
              if (widget.suffix != null) 
              ...{
                widget.suffix!
              },
            ],
          ),
        ),
      ),
    );
  }
}
