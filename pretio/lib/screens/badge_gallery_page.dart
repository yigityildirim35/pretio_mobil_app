import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../data/badge_repository.dart';
import '../models/badge_definition.dart';
import '../models/user_badge_progress.dart';
import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';
import 'package:pretio/l10n/app_localizations.dart';

class BadgeGalleryPage extends StatelessWidget {
  const BadgeGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final cardBgColor = theme.cardColor;
    final mutedTextColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    final provider = Provider.of<ProfileProvider>(context);
    final progresses = provider.badges;
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final l10n = AppLocalizations.of(context)!;

    // Calculate Global Stats
    int totalLevels = BadgeRepository.badges.length * 10;
    int achievedLevels = progresses.fold(0, (sum, b) => sum + b.currentLevel);
    double completionPercentage = totalLevels > 0
        ? achievedLevels / totalLevels
        : 0.0;
    int maxedBadges = progresses.where((b) => b.isCompleted).length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: mutedTextColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.badgeGallery.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: theme.dividerColor.withValues(alpha: 0.1),
            height: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Toplam İlerleme Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.totalProgress,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$achievedLevels / $totalLevels ${l10n.totalLevels}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: theme.canvasColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: completionPercentage.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(completionPercentage * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right side Circle with Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: Color(0xFFFFC107),
                            size: 32,
                          ),
                          Text(
                            '$maxedBadges ${l10n.maxShort}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFFC107),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Vertical List of Badges
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: BadgeRepository.badges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final def = BadgeRepository.badges[index];
                  final progress = provider.badges.firstWhere(
                    (b) => b.badgeId == def.id,
                    orElse: () => UserBadgeProgress.initial(def.id),
                  );
                  return _buildBadgeItem(
                    context,
                    def,
                    progress,
                    theme,
                    cardBgColor,
                    textColor,
                    mutedTextColor,
                    bgColor,
                    is3D,
                  );
                },
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeItem(
    BuildContext context,
    BadgeDefinition def,
    UserBadgeProgress progress,
    ThemeData theme,
    Color statBgColor,
    Color textColor,
    Color mutedTextColor,
    Color bgColor,
    bool is3D,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final isUnlocked = progress.currentLevel > 0;
    final config = isUnlocked
        ? def.levelConfigs[progress.currentLevel - 1]
        : def.levelConfigs[0];

    // Base Colors Map
    final themeBaseColor = isUnlocked ? def.baseColor : Colors.grey.shade600;

    final configForNext = progress.currentLevel < def.maxLevel
        ? def.levelConfigs[progress.currentLevel]
        : def.levelConfigs.last;
    double percentage = progress.isCompleted
        ? 1.0
        : (progress.currentProgress / configForNext.threshold).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _showBadgeDetail(
        context,
        def,
        progress,
        config,
        statBgColor,
        textColor,
        mutedTextColor,
        theme.dividerColor,
        themeBaseColor,
        bgColor,
        is3D,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: buildCardDecoration(
          context: context,
          is3D: is3D,
          borderRadius: 16,
          shadowColor: isUnlocked && is3D
              ? HSLColor.fromColor(themeBaseColor)
                  .withLightness((HSLColor.fromColor(themeBaseColor).lightness * 0.8).clamp(0.0, 1.0))
                  .toColor()
              : null,
          borderColor: isUnlocked && is3D
              ? HSLColor.fromColor(themeBaseColor)
                  .withLightness((HSLColor.fromColor(themeBaseColor).lightness * 1.2).clamp(0.0, 1.0))
                  .toColor()
                  .withValues(alpha: 0.5)
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? themeBaseColor
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(14),
              ),
              child: isUnlocked
                  ? Icon(
                      def.iconAsset,
                      color: Colors.white,
                      size: 28,
                    )
                  : Icon(
                      Icons.lock,
                      color: isDark ? Colors.white24 : Colors.grey.shade400,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 14),

            // Text and Progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          def.localizedTitle(context),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: !isUnlocked ? textColor.withValues(alpha: 0.5) : textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnlocked)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            progress.isCompleted ? l10n.maxShort : '${l10n.levelShort} ${progress.currentLevel}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: themeBaseColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked ? def.localizedDescription(context) : '🔒 ${def.localizedDescription(context)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: mutedTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!progress.isCompleted) ...[
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeBaseColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(
    BuildContext context,
    BadgeDefinition def,
    UserBadgeProgress progress,
    BadgeLevelConfig currentConfig,
    Color statBgColor,
    Color textColor,
    Color mutedTextColor,
    Color borderColor,
    Color frameColor,
    Color bgColor,
    bool is3D,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: statBgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final configForNext = progress.currentLevel < def.maxLevel
            ? def.levelConfigs[progress.currentLevel]
            : def.levelConfigs.last;

        double perc = progress.isCompleted
            ? 1.0
            : (progress.currentProgress / configForNext.threshold).clamp(
                0.0,
                1.0,
              );

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 32,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful glowing icon display
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: progress.currentLevel > 0
                      ? frameColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  border: Border.all(
                    color: progress.currentLevel > 0 ? frameColor : Colors.grey,
                    width: 4,
                  ),
                  boxShadow: [],
                ),
                child: Icon(
                  def.iconAsset,
                  color: progress.currentLevel > 0 ? frameColor : Colors.grey,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                def.localizedTitle(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: progress.currentLevel > 0
                      ? frameColor.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  def.type == BadgeType.streak
                      ? l10n.streakBadge
                      : l10n.cumulativeBadge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: progress.currentLevel > 0 ? frameColor : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                def.localizedDescription(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: mutedTextColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              if (progress.isCompleted) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: frameColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: frameColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.workspace_premium, color: frameColor),
                      const SizedBox(width: 8),
                      Text(
                        l10n.maxLevelReached,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: frameColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Specific Requirement Text Prompt requested by USER
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.nextLevelTarget(configForNext.threshold - progress.currentProgress),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: frameColor,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Progress Bar Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.levelShort} ${progress.currentLevel}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${l10n.levelShort} ${progress.currentLevel + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: mutedTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: perc,
                    child: Container(
                      decoration: BoxDecoration(
                        color: frameColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.progressLabel(progress.currentProgress, configForNext.threshold),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
