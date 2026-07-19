import 'package:flutter/material.dart';

enum BadgeType { streak, cumulative }

enum BadgeTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond;

  Color get color {
    switch (this) {
      case BadgeTier.bronze:
        return const Color(0xFFCD7F32);
      case BadgeTier.silver:
        return const Color(0xFFC0C0C0);
      case BadgeTier.gold:
        return const Color(0xFFFFD700);
      case BadgeTier.platinum:
        return const Color(0xFFE5E4E2);
      case BadgeTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }
}

class BadgeLevelConfig {
  final int levelNumber;
  final int threshold;
  final int rewardXP;
  final BadgeTier tierColor;

  const BadgeLevelConfig({
    required this.levelNumber,
    required this.threshold,
    this.rewardXP = 0,
    required this.tierColor,
  });
}

class BadgeDefinition {
  final String id;
  final String title;
  final String description;
  final BadgeType type;
  final int maxLevel;
  final String category;
  final List<BadgeLevelConfig> levelConfigs;
  final IconData
  iconAsset; // Using IconData for simplicity as requested by existing UI
  final bool isSeasonal;
  final DateTime? startDate;
  final DateTime? endDate;
  final Color baseColor;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.maxLevel = 10,
    required this.category,
    required this.levelConfigs,
    required this.iconAsset,
    this.isSeasonal = false,
    this.startDate,
    this.endDate,
    required this.baseColor,
  });

  bool get isValid => maxLevel <= 10 && levelConfigs.length == maxLevel;
}
