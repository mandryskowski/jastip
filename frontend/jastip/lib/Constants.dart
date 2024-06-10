import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:jastip/Listing.dart';
import 'JsonSerializable.dart';

RegExp stringFormat = RegExp(".*");
RegExp intFormat = RegExp("[0-9]");
RegExp dateFormat = RegExp("[0-9]|-");

Map<Type, RegExp> regExpFormatter = {String: stringFormat, int: intFormat, DateTime: dateFormat};

// Color constants
const Color primaryColor = Color(0xFFDA2222);
const Color primaryColorDark = Color(0xFF991717);
const Color backgroundColor = Colors.white; 
const Color backgroundColorData = Color.fromRGBO(217, 217, 217, 1.0); 

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

TextStyle tradeMarkStyle = GoogleFonts.caveat(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    shadows: [
      BoxShadow(
        color: Colors.black,
        blurRadius: 10,
        offset: Offset(0, 3),
      ),
    ],
  ),
);

// Padding constants
const EdgeInsets paddingAll15 = EdgeInsets.all(15.0);
const EdgeInsets paddingHorizontal5 = EdgeInsets.symmetric(horizontal: 5.0);
const EdgeInsets paddingVertical10 = EdgeInsets.symmetric(vertical: 10.0);

// Const available orderings
const List<String> orderings = ["Size", "Date"];

class HttpRequests {
  static Future<Map<String, dynamic>> postRequest(Map<String, String> args, String table, {bool ret = false}) async {
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
      return ret ? json.decode(response.body) : {};
    } else {
      print('POST request failed with status: ${response.statusCode}');
      print('Failed body: ${body}');
      throw Exception('Failed to load data');
    }
  }

  static Future<List<T>> fetchData<T extends JsonSerializable>(
    String table, 
    Map<String, String> args,
  ) async {
    final response = await http.get(Uri.parse(
        "https://jastip-backend-3b036fb5403c.herokuapp.com/${table}${getParameters(args)}"));
    
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body);
      return List<T>.from(list.map((item) => JsonSerializableFactory.fromJson<T>(item)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  static String getParameters(Map<String, String> args) {
    StringBuffer sb = StringBuffer();
    sb.write("?");
    for (var entry in args.entries) {
      if (entry.value.isNotEmpty) {
        sb.write("${entry.key}=${entry.value}&");
      }
    }
    return sb.toString();
  }
}

class LoggedInUserData {
  static final LoggedInUserData _instance = LoggedInUserData._internal();

  // Private constructor
  LoggedInUserData._internal();

  // Factory constructor to return the same instance
  factory LoggedInUserData() {
    return _instance;
  }

  UserInfo userInfo = UserInfo(id : 4);

  // Other user-related data can be added here
}

