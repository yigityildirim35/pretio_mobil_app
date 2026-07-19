import '../models/user_badge_progress.dart';
import '../providers/transaction_provider.dart';
import '../providers/subscription_provider.dart';
import 'badge_repository.dart';

class BadgeEngine {
  /// Evaluates all badges globally based on current state of transactions, shadow transactions, and daily goals.
  /// Returns a map of Badge ID to updated UserBadgeProgress.
  static Map<String, UserBadgeProgress> evaluateAll({
    required Map<String, UserBadgeProgress> currentProgresses,
    required TransactionProvider txProv,
    required SubscriptionProvider subProv,
  }) {
    final Map<String, UserBadgeProgress> updatedProgresses = {};

    final transactions = txProv.transactions;
    final shadowTransactions = txProv.shadowTransactions;

    // --- 6 NEW BADGE CALCULATIONS ---

    // 1. Kutsal Seri (Max Streak / Current Streak)
    // Synchronize directly with TransactionProvider to ensure perfect alignment with UI (AppBar)
    // and inherently fix the Ghost Days and 'Today is not over' exploits, since txProv handles them.
    int maxStreak = txProv.longestStreak;
    int currentStreak = txProv.currentStreak;

    // 2. Cüzdan Bekçisi (Total No-Spend Days)
    // Counts unique days where the user explicitly recorded a 'no_spend' transaction.
    Set<String> noSpendDays = {};
    for (var t in transactions) {
      if (t.category == 'no_spend') {
        String dayKey = "${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}";
        noSpendDays.add(dayKey);
      }
    }
    int totalNoSpendDays = noSpendDays.length;

    // 3. Duygu Dedektifi (Transactions with Emotion)
    int emotionalTxs = transactions.where((t) {
      if (t.amount <= 0) return false; // Real expenses only
      String e = t.emotion.trim().toLowerCase();
      // Since default is 'none', any other string means the user explicitly chose an emotion.
      return e.isNotEmpty && e != 'none'; 
    }).length;

    // 4. Düzen Uzmanı (Categorized / Necessity Transactions)
    // The user clarified that 'özel bir kategori' meant Necessity (Need/Want/Obligation)
    int categorizedTxs = transactions.where((t) {
      if (t.amount <= 0) return false; // Real expenses only
      String n = t.necessity.trim().toLowerCase();
      // Since default is 'none', any explicit choice counts.
      return n.isNotEmpty && n != 'none';
    }).length;

    // 5. Veri Kurdu (Total Logged Expenses)
    int totalExpenses = transactions.where((t) => t.amount > 0).length;

    // 6. Vazgeçiş Ustası (Shadow Items)
    int shadowCount = shadowTransactions.length;

    // --- MAP CALCULATIONS TO BADGE IDs ---
    
    // Evaluate only current active badges in the repository
    for (final def in BadgeRepository.badges) {
      final existingProgress = currentProgresses[def.id] ?? UserBadgeProgress.initial(def.id);

      UserBadgeProgress newProgress = UserBadgeProgress(
        badgeId: existingProgress.badgeId,
        currentLevel: existingProgress.currentLevel,
        currentProgress: existingProgress.currentProgress,
        isCompleted: existingProgress.isCompleted,
        lastUpdated: existingProgress.lastUpdated,
      );

      double rawCalculatedValue = 0;

      switch (def.id) {
        case 'kutsal_seri':
          rawCalculatedValue = currentStreak.toDouble();
          break;
        case 'cuzdan_bekcisi':
          rawCalculatedValue = totalNoSpendDays.toDouble();
          break;
        case 'duygu_dedektifi':
          rawCalculatedValue = emotionalTxs.toDouble();
          break;
        case 'duzen_uzmani':
          rawCalculatedValue = categorizedTxs.toDouble();
          break;
        case 'veri_kurdu':
          rawCalculatedValue = totalExpenses.toDouble();
          break;
        case 'vazgecis_ustasi':
          rawCalculatedValue = shadowCount.toDouble();
          break;
      }

      int calculatedValue = rawCalculatedValue.toInt();
      newProgress.currentProgress = calculatedValue;

      // Ensure historical max determines level for Kutsal Seri
      int actualMaxAchievement = calculatedValue;
      if (def.id == 'kutsal_seri') {
        actualMaxAchievement = maxStreak;
      }

      int calculatedLevel = existingProgress.currentLevel;
      for (var config in def.levelConfigs) {
        if (actualMaxAchievement >= config.threshold) {
          if (config.levelNumber > calculatedLevel) {
            calculatedLevel = config.levelNumber;
          }
        } else {
          break;
        }
      }

      newProgress.currentLevel = calculatedLevel;
      newProgress.isCompleted = newProgress.currentLevel >= def.maxLevel;
      newProgress.lastUpdated = DateTime.now();

      updatedProgresses[def.id] = newProgress;
    }

    return updatedProgresses;
  }
}
