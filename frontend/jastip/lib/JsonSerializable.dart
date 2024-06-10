import 'package:flutter/material.dart';
import 'ReviewsListing.dart';
import 'Listing.dart';

abstract class JsonSerializable {
  factory JsonSerializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

typedef JsonConstructor<T> = T Function(Map<String, dynamic> json);

class JsonSerializableFactory {
  static final Map<Type, JsonConstructor<JsonSerializable>> _constructors = {
    Review: (json) => Review.fromJson(json),
    Listing: (json) => Listing.fromJson(json),
    // Add other classes here
  };

  static T fromJson<T extends JsonSerializable>(Map<String, dynamic> json) {
    final constructor = _constructors[T];
    if (constructor != null) {
      return constructor(json) as T;
    } else {
      throw Exception('Constructor not found for type $T');
    }
  }
}