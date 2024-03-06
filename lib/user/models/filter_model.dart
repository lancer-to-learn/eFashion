// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FilterModel filterModelFromJson(String str) =>
    FilterModel.fromJson(json.decode(str));

class FilterModel {
  FilterModel({
    required this.filters,
  });

  List<Filter> filters;

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        filters: List<Filter>.from(
            json["filters"].map((x) => Filter.fromJson(x))),
      );
}

class Filter {
  Filter({
    required this.name,
    required this.min,
    required this.max,
  });

  String name;
  int min;
  int max;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        name: json["name"],
        min: json["min"],
        max: json["max"],
      );
}
