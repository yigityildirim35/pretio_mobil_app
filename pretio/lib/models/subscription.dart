import 'package:flutter/material.dart';

class Subscription {
  final String id;
  final String name;
  final String price; // e.g., "189.99"
  final String date; // Next payment date
  final String cycle; // e.g., "Aylık"
  final IconData icon;
  final Color color;
  final String? lastBilledDate;
  final String necessity; // 'need' or 'want'
  final String emotion; // 'happy', 'neutral', 'sad'
  final String? logoUrl;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.date,
    required this.cycle,
    required this.icon,
    required this.color,
    this.lastBilledDate,
    this.necessity = 'need', // default to need
    this.emotion = 'neutral', // default to neutral
    this.logoUrl,
  });

  Subscription copyWith({
    String? id,
    String? name,
    String? price,
    String? date,
    String? cycle,
    IconData? icon,
    Color? color,
    String? lastBilledDate,
    String? necessity,
    String? emotion,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      cycle: cycle ?? this.cycle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      lastBilledDate: lastBilledDate ?? this.lastBilledDate,
      necessity: necessity ?? this.necessity,
      emotion: emotion ?? this.emotion,
      logoUrl: logoUrl ?? logoUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'date': date,
    'cycle': cycle,
    'iconCode': icon.codePoint,
    'colorValue': color.toARGB32(),
    'lastBilledDate': lastBilledDate,
    'necessity': necessity,
    'emotion': emotion,
    'logoUrl': logoUrl,
  };

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      date: json['date'],
      cycle: json['cycle'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
      lastBilledDate: json['lastBilledDate'],
      necessity: json['necessity'] ?? 'need',
      emotion: json['emotion'] ?? 'neutral',
      logoUrl: json['logoUrl'],
    );
  }
}
