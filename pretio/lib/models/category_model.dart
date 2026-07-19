import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int iconCode;
  final int colorValue;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    this.isDefault = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'isDefault': isDefault,
    };
  }

  // Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  // Helper to get IconData
  IconData get iconData => IconData(iconCode, fontFamily: 'MaterialIcons');

  // Helper to get Color
  Color get color => Color(colorValue);
}
