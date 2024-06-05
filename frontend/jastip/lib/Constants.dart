import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

RegExp stringFormat = RegExp(".*");
RegExp intFormat = RegExp("[0-9]");
RegExp dateFormat = RegExp("[0-9]|-");

Map<Type, RegExp> regExpFormatter = {String: stringFormat, int: intFormat, DateTime: dateFormat};

// Color constants
const Color primaryColor = Color(0xFFDA2222);
const Color primaryColorDark = Color(0xFF991717);
const Color backgroundColor = Colors.white; 
const Color backgroundColorData = Color.fromRGBO(217, 217, 217, 100); 

// Text style constants
const TextStyle titleTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

const TextStyle fieldTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const TextStyle searchBarTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

// Padding constants
const EdgeInsets paddingAll15 = EdgeInsets.all(15.0);
const EdgeInsets paddingHorizontal5 = EdgeInsets.symmetric(horizontal: 5.0);
const EdgeInsets paddingVertical10 = EdgeInsets.symmetric(vertical: 10.0);

// Const available orderings
const List<String> orderings = ["Size", "Date"];

class HttpRequests {
  static void postRequest(Map<String, String> args, String table) async {
    var body = json.encode(args);

    var response = await http.post(
      Uri.parse("https://jastip-backend-3b036fb5403c.herokuapp.com/${table}"),
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
      print('Failed body: ${body}');
    }
  }
}
