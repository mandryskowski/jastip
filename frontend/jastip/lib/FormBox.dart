import 'dart:convert';
import 'FormElement.dart';

import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/ListingPage.dart';
import 'package:http/http.dart' as http;

class Formbox extends StatefulWidget {
  const Formbox({
    super.key,
    required this.title,
    required this.fields,
    this.checkboxTitles = const [],
    this.constraints = const BoxConstraints(),
    this.httpMethod = "GET"
  });

  final String title;
  final List<MapEntry<String, List<SearchBarContentsTuple>>> fields;
  final List<String> checkboxTitles;
  final BoxConstraints constraints;
  final String httpMethod;

  @override
  _FormboxState createState() => _FormboxState();
}

class _FormboxState extends State<Formbox> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _checkboxValues = {};
  int _resultCount = 0;

  @override
  void initState() {
    super.initState();
    for (var group in widget.fields) {
      for (var field in group.value) {
        final controller = TextEditingController();
        controller.addListener(_fetchResultCount);
        _controllers[field.dbQueryParam] = controller;
      }
    }
    for (var title in widget.checkboxTitles) {
      _checkboxValues[title] = false;
    }
    _fetchResultCount();
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
      mp[entry.key] = entry.value.text;
    }
    for (var entry in _checkboxValues.entries) {
      mp[entry.key] = entry.value.toString();
    }

    String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    if(widget.httpMethod == "POST") {
      _postRequest(mp);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListingPage.generic(currentRoute), settings: RouteSettings(name: '/ListingPage')));
    }
    else if(widget.httpMethod == "GET") {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListingPage(args: mp, initialRoute: currentRoute,), settings: RouteSettings(name: '/ListingPage')));
    } else {
      print("INVALID HTTP METHOD");
    }
  }

  void _postRequest(Map<String, String> args) async {
    var body = json.encode(args);

    var response = await http.post(
      Uri.parse("https://jastip-backend-3b036fb5403c.herokuapp.com/auctions"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('POST request successful');
      print('Response body: ${response.body}');
    } else {
      print('POST request failed with status: ${response.statusCode}');
    }
  }

  void _fetchResultCount() async {
    if (widget.httpMethod != 'GET')
      return;
    var uri = Uri.parse("https://jastip-backend-3b036fb5403c.herokuapp.com/auctions${getParameters()}");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      setState(() {
        _resultCount = list.length;
      });
    } else {
      print('GET request failed with status: ${response.statusCode}');
    }
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
                    _fetchResultCount();
                  },
                ),
              ),
              if (widget.httpMethod == 'GET')
              ...{
                Center(
                  child: Text('Number of results: $_resultCount'),
                )
              },
              Center(
                child: SubmitButton(
                  onPressed: _submit,
                  buttonText: 'Submit',
                  enabled: widget.httpMethod != 'GET' ||  _resultCount > 0,
                ),
              ),
            ],
          ),
        ),
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
