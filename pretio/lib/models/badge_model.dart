import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color bgColor;
  final bool isUnlocked;
  final int currentProgress;
  final int targetProgress;
  final int currentLevel;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.bgColor,
    this.isUnlocked = false,
    this.currentProgress = 0,
    this.targetProgress = 1,
    this.currentLevel = 0,
  });

  BadgeModel copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? bgColor,
    bool? isUnlocked,
    int? currentProgress,
    int? targetProgress,
    int? currentLevel,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      bgColor: bgColor ?? this.bgColor,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconCode': icon.codePoint,
    'colorValue': bgColor.toARGB32(),
    'isUnlocked': isUnlocked,
    'currentProgress': currentProgress,
    'targetProgress': targetProgress,
    'currentLevel': currentLevel,
  };

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      bgColor: Color(json['colorValue']),
      isUnlocked: json['isUnlocked'],
      currentProgress: json['currentProgress'],
      targetProgress: json['targetProgress'],
      currentLevel: json['currentLevel'],
    );
  }
}
