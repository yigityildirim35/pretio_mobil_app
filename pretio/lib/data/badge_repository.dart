import 'package:flutter/material.dart';
import '../models/badge_definition.dart';
import 'package:pretio/l10n/app_localizations.dart';

extension BadgeLocalization on BadgeDefinition {
  String localizedTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return title;
    switch (id) {
      case 'kutsal_seri': return l10n.badgeKutsalSeriTitle;
      case 'cuzdan_bekcisi': return l10n.badgeCuzdanBekcisiTitle;
      case 'duygu_dedektifi': return l10n.badgeDuyguDedektifiTitle;
      case 'duzen_uzmani': return l10n.badgeDuzenUzmaniTitle;
      case 'veri_kurdu': return l10n.badgeVeriKurduTitle;
      case 'vazgecis_ustasi': return l10n.badgeVazgecisUstasiTitle;
      default: return title;
    }
  }

  String localizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return description;
    switch (id) {
      case 'kutsal_seri': return l10n.badgeKutsalSeriDesc;
      case 'cuzdan_bekcisi': return l10n.badgeCuzdanBekcisiDesc;
      case 'duygu_dedektifi': return l10n.badgeDuyguDedektifiDesc;
      case 'duzen_uzmani': return l10n.badgeDuzenUzmaniDesc;
      case 'veri_kurdu': return l10n.badgeVeriKurduDesc;
      case 'vazgecis_ustasi': return l10n.badgeVazgecisUstasiDesc;
      default: return description;
    }
  }
}

class BadgeRepository {
  static List<BadgeLevelConfig> _generateLevels(List<int> thresholds) {
    if (thresholds.length != 10) {
      throw Exception(
        'Must provide exactly 10 thresholds. Provided: ${thresholds.length}',
      );
    }

    return List.generate(10, (index) {
      BadgeTier tier;
      if (index < 2) {
        tier = BadgeTier.bronze;
      } else if (index < 4)
        tier = BadgeTier.silver;
      else if (index < 7)
        tier = BadgeTier.gold;
      else if (index < 9)
        tier = BadgeTier.platinum;
      else
        tier = BadgeTier.diamond;

      return BadgeLevelConfig(
        levelNumber: index + 1,
        threshold: thresholds[index],
        rewardXP: (index + 1) * 50,
        tierColor: tier,
      );
    });
  }

  static final List<BadgeDefinition> badges = [
    // 1. Kutsal Seri (The Streak)
    BadgeDefinition(
      id: 'kutsal_seri',
      title: 'Kutsal Seri',
      description: 'Harcama yapmadığın kesintisiz gün sayısı.',
      type: BadgeType.streak,
      category: 'budget',
      iconAsset: Icons.whatshot, // alev
      baseColor: const Color(0xFFFFC107), // Amber - Alev rengi
      levelConfigs: _generateLevels([7, 14, 30, 60, 90, 135, 180, 225, 300, 365]),
    ),

    // 2. Cüzdan Bekçisi (Zero Spend Days)
    BadgeDefinition(
      id: 'cuzdan_bekcisi',
      title: 'Cüzdan Bekçisi',
      description: 'Hiç harcama yapılmayan toplam gün sayısı.',
      type: BadgeType.cumulative,
      category: 'savings',
      iconAsset: Icons.security,
      baseColor: const Color(0xFF4CAF50), // Green
      levelConfigs: _generateLevels([7, 15, 30, 60, 90, 120, 180, 225, 300, 365]),
    ),

    // 3. Duygu Dedektifi (Emotional Tracking)
    BadgeDefinition(
      id: 'duygu_dedektifi',
      title: 'Duygu Dedektifi',
      description: 'Duygu durumu girilmiş toplam işlem sayısı.',
      type: BadgeType.cumulative,
      category: 'tracking',
      iconAsset: Icons.psychology,
      baseColor: const Color(0xFF2196F3), // Blue
      levelConfigs: _generateLevels([10, 30, 50, 70, 100, 150, 200, 250, 300, 400]),
    ),

    // 4. Düzen Uzmanı (Categorized Transactions)
    BadgeDefinition(
      id: 'duzen_uzmani',
      title: 'Düzen Uzmanı',
      description: 'Özel bir kategori seçilmiş toplam işlem sayısı.',
      type: BadgeType.cumulative,
      category: 'tracking',
      iconAsset: Icons.category,
      baseColor: const Color(0xFF9C27B0), // Purple
      levelConfigs: _generateLevels([10, 30, 50, 70, 100, 150, 200, 250, 300, 400]),
    ),

    // 5. Veri Kurdu (Total Logged Transactions)
    BadgeDefinition(
      id: 'veri_kurdu',
      title: 'Veri Kurdu',
      description: 'Sisteme girilen toplam harcama işlemi sayısı.',
      type: BadgeType.cumulative,
      category: 'tracking',
      iconAsset: Icons.data_usage,
      baseColor: const Color(0xFFff5722), // Deep Orange
      levelConfigs: _generateLevels([10, 30, 50, 70, 100, 150, 200, 250, 300, 400]),
    ),

    // 6. Vazgeçiş Ustası (Shadow Items)
    BadgeDefinition(
      id: 'vazgecis_ustasi',
      title: 'Vazgeçiş Ustası',
      description: 'Almaktan vazgeçilip gölge bütçeye atılan işlem sayısı.',
      type: BadgeType.cumulative,
      category: 'savings',
      iconAsset: Icons.not_interested,
      baseColor: const Color(0xFFE91E63), // Pink
      levelConfigs: _generateLevels([10, 20, 30, 40, 50, 60, 70, 80, 90, 100]),
    ),
  ];
}
