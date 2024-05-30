import 'package:flutter/material.dart';

RegExp StringFormat = RegExp(".*");
RegExp IntFormat = RegExp("[0-9]");
RegExp DateFormat = RegExp("[0-9]|-");

Map<Type, RegExp> regExpFormatter = {String: StringFormat, int: IntFormat, DateTime: DateFormat};