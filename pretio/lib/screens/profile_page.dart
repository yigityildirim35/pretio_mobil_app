import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/subscription_provider.dart';
import 'badge_gallery_page.dart';
import 'settings_page.dart';
import 'subscriptions_page.dart';
import '../models/user_badge_progress.dart';
import '../models/badge_definition.dart';
import '../data/badge_repository.dart';
import '../features/brand_search/presentation/widgets/brand_logo_avatar.dart';
import '../widgets/animated_amount.dart';
import '../utils/card_decoration.dart';
import '../providers/theme_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final double salary;
  final double weeklyHours;
  final ValueChanged<double> onSalaryChanged;

  const ProfilePage({
    super.key,
    required this.salary,
    required this.weeklyHours,
    required this.onSalaryChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  String _getFinancialIqText(TransactionProvider provider, AppLocalizations l10n) {
    if (provider.transactions.isEmpty) return l10n.percentNeed(0);
    int needsCount = 0;
    int wantsCount = 0;
    int obligationCount = 0;

    for (var t in provider.transactions) {
      if (t.necessity == 'need' || t.necessity == 'necessity') {
        needsCount++;
      } else if (t.necessity == 'want') {
        wantsCount++;
      } else if (t.necessity == 'obligation' || t.necessity == 'zorunluluk') {
        obligationCount++;
      }
    }

    int total = needsCount + wantsCount + obligationCount;
    if (total == 0) return l10n.percentNeed(0);

    if (needsCount >= wantsCount && needsCount >= obligationCount) {
      int percent = ((needsCount / total) * 100).round();
      return l10n.percentNeed(percent);
    } else if (wantsCount >= needsCount && wantsCount >= obligationCount) {
      int percent = ((wantsCount / total) * 100).round();
      return l10n.percentWant(percent);
    } else {
      int percent = ((obligationCount / total) * 100).round();
      return l10n.percentObligation(percent);
    }
  }

  double _calculateTotalSpent(TransactionProvider provider) {
    return provider.transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null && mounted) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: AppLocalizations.of(context)!.editPhoto,
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true,
            ),
            IOSUiSettings(
              title: AppLocalizations.of(context)!.editPhoto,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            ),
          ],
        );

        if (croppedFile != null && mounted) {
          await Provider.of<ProfileProvider>(
            context,
            listen: false,
          ).updatePickedImage(croppedFile.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  void _showAvatarSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.selectAvatar,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 10,
                  itemBuilder: (_, index) {
                    if (index == 9) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }

                    final assetPath = 'assets/Avatars/${index + 1}.png';
                    final provider = Provider.of<ProfileProvider>(context);
                    final isSelected =
                        provider.selectedAvatarAsset == assetPath;

                    return GestureDetector(
                      onTap: () async {
                        await Provider.of<ProfileProvider>(
                          context,
                          listen: false,
                        ).updateAvatar(assetPath);
                        if (mounted) Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                          image: DecorationImage(
                            image: AssetImage(assetPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider? _getProfileImage(ProfileProvider provider) {
    if (provider.pickedImage != null) {
      return FileImage(provider.pickedImage!);
    } else if (provider.selectedAvatarAsset != null) {
      return AssetImage(provider.selectedAvatarAsset!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(
      context,
    );
    final txProvider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    // Calc Stats
    final int streak = txProvider.currentStreak;
    final int longestStreak = txProvider.longestStreak;

    final double totalSpentBase = _calculateTotalSpent(txProvider);

    // Define colors used in the requested design
    final primaryColor = Theme.of(context).colorScheme.primary;
    const orangeColor = Color(0xFFff9600);
    const blueColor = Color(0xFF1cb0f6);

    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final bgColor = theme.scaffoldBackgroundColor;
    final statBgColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final mutedTextColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final isDark = theme.brightness == Brightness.dark;

    final provider = Provider.of<ProfileProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    // Calculate Top 5 in-progress badges
    final List<Map<String, dynamic>>
    sortedProgressInfo = BadgeRepository.badges.map((def) {
      final progress = provider.badges.firstWhere(
        (b) => b.badgeId == def.id,
        orElse: () => UserBadgeProgress.initial(def.id),
      );

      final config = progress.currentLevel > 0
          ? def.levelConfigs[progress.currentLevel - 1]
          : def.levelConfigs[0];

      final configForNext = progress.currentLevel < def.maxLevel
          ? def.levelConfigs[progress.currentLevel]
          : def.levelConfigs.last;

      double percentage = progress.isCompleted
          ? 1.0
          : (progress.currentProgress / configForNext.threshold).clamp(
              0.0,
              1.0,
            );

      // Sort score: prioritize higher levels and higher percentages. Maxed out gets highest priority.
      return {
        'def': def,
        'progress': progress,
        'config': config,
        'percentage': percentage,
        'sortScore': progress.isCompleted
            ? 9999.0
            : (progress.currentLevel * 100) + (percentage * 100),
      };
    }).toList();

    // Sort descending by sortScore
    sortedProgressInfo.sort(
      (a, b) => (b['sortScore'] as double).compareTo(a['sortScore'] as double),
    );

    final top5Badges = sortedProgressInfo.take(5).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          l10n.profile.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1.2,
            color: mutedTextColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: borderColor, height: 2),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: mutedTextColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Avatar Section
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _getProfileImage(profileProvider) != null
                          ? Image(
                              image: _getProfileImage(profileProvider)!,
                              fit: BoxFit.cover,
                            )
                          : Container(color: Colors.grey[300]),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showAvatarSelectionDialog,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: blueColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: bgColor, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profileProvider.name.isEmpty ? 'Kullanıcı' : profileProvider.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),

            const SizedBox(height: 24),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statistics,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    children: [
                      // Stat 1: En İyi Seri
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: buildCardDecoration(
                          context: context,
                          is3D: themeProvider.is3DEnabled,
                          borderRadius: 16,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$longestStreak',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: orangeColor,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  l10n.highestStreak.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: mutedTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Stat 2: Toplam Tasarruf (Spend)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: buildCardDecoration(
                          context: context,
                          is3D: themeProvider.is3DEnabled,
                          borderRadius: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt, color: primaryColor, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: AnimatedAmount(
                                      amount: totalSpentBase,
                                      formatter: (val) =>
                                          currencyProvider.getDisplayValue(val),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: primaryColor,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    l10n.totalSpending.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: mutedTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stat 3: Zaman Kazancı
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: buildCardDecoration(
                          context: context,
                          is3D: themeProvider.is3DEnabled,
                          borderRadius: 16,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: orangeColor,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$streak',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: orangeColor,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  l10n.currentStreakLabel.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: mutedTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Stat 4: Finansal IQ
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: buildCardDecoration(
                          context: context,
                          is3D: themeProvider.is3DEnabled,
                          borderRadius: 16,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              color: Color.fromARGB(255, 187, 30, 135),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getFinancialIqText(txProvider, l10n),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: const Color.fromARGB(
                                      255,
                                      187,
                                      30,
                                      135,
                                    ),
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Subscriptions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.subscriptions,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionsPage(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.seeAll.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child: Consumer<SubscriptionProvider>(
                builder: (context, provider, child) {
                  final subscriptions = provider.subscriptions;
                  if (subscriptions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        l10n.noSubscriptionsYet,
                        style: TextStyle(
                          color: mutedTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Row(
                    children: subscriptions.map((sub) {
                      return _buildSubscriptionCard(
                        company: sub.name,
                        price: currencyProvider.getDisplayValue(double.tryParse(sub.price) ?? 0.0, compact: true),
                        date: sub.date,
                        icon: sub.icon,
                        color: sub.color,
                        logoUrl: sub.logoUrl,
                        shadowColor: HSLColor.fromColor(sub.color)
                            .withLightness(
                              (HSLColor.fromColor(sub.color).lightness * 0.8)
                                  .clamp(0.0, 1.0),
                            )
                            .toColor(),
                        statBgColor: statBgColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        mutedTextColor: mutedTextColor,
                        is3D: themeProvider.is3DEnabled,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Achievements Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.badgesAndAchievements,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BadgeGalleryPage(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.seeAll,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Top 5 Badge List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: top5Badges.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final info = top5Badges[index];
                      final BadgeDefinition def =
                          info['def'] as BadgeDefinition;
                      final UserBadgeProgress progress =
                          info['progress'] as UserBadgeProgress;
                      final BadgeLevelConfig config =
                          info['config'] as BadgeLevelConfig;
                      final double percentage = info['percentage'] as double;

                      final bool isUnlocked = progress.currentLevel > 0;
                      final themeBaseColor = isUnlocked
                          ? def.baseColor
                          : Colors.grey.shade600;

                      return GestureDetector(
                        onTap: () => _showBadgeDetail(
                          context,
                          def,
                          progress,
                          config,
                          statBgColor,
                          textColor,
                          mutedTextColor,
                          borderColor,
                          themeBaseColor,
                          bgColor,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: buildCardDecoration(
                            context: context,
                            is3D: themeProvider.is3DEnabled,
                            borderRadius: 16,
                            showBorder: false,
                            shadowColor: isUnlocked && themeProvider.is3DEnabled
                                ? HSLColor.fromColor(themeBaseColor).withLightness((HSLColor.fromColor(themeBaseColor).lightness * 0.8).clamp(0.0, 1.0)).toColor()
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
                                      : (isDark
                                            ? Colors.white.withValues(alpha: 0.05)
                                            : Colors.grey.shade200),
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
                                        color: isDark
                                            ? Colors.white24
                                            : Colors.grey.shade400,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            def.localizedTitle(context),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: !isUnlocked
                                                  ? textColor.withValues(alpha: 0.5)
                                                  : textColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isUnlocked)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                                progress.isCompleted
                                                    ? l10n.maxShort
                                                    : '${l10n.levelShort} ${progress.currentLevel}',
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
                                      isUnlocked
                                          ? def.localizedDescription(context)
                                          : '🔒 ${def.localizedDescription(context)}',
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
                                          color: isDark
                                              ? const Color(0xFF1E293B)
                                              : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: percentage,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: themeBaseColor,
                                              borderRadius:
                                                  BorderRadius.circular(3),
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
                    },
                  ),
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
              Builder(
                builder: (context) {
                  final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  final isUnlocked = progress.currentLevel > 0;
                  
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? (is3D ? frameColor : frameColor.withValues(alpha: 0.1))
                          : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1)),
                      border: Border.all(
                        color: is3D
                            ? (isUnlocked
                                ? HSLColor.fromColor(frameColor).withLightness((HSLColor.fromColor(frameColor).lightness * 1.2).clamp(0.0, 1.0)).toColor().withValues(alpha: 0.5)
                                : (isDark ? Colors.white12 : Colors.grey.shade300))
                            : (isUnlocked ? frameColor : Colors.grey),
                        width: is3D ? 2 : 4,
                      ),
                      boxShadow: is3D
                          ? [
                              BoxShadow(
                                color: isUnlocked
                                    ? HSLColor.fromColor(frameColor).withLightness((HSLColor.fromColor(frameColor).lightness * 0.8).clamp(0.0, 1.0)).toColor()
                                    : (isDark ? Colors.black26 : Colors.grey.shade300),
                                offset: const Offset(0, 6),
                                blurRadius: 0,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      def.iconAsset,
                      color: is3D && isUnlocked ? Colors.white : (isUnlocked ? frameColor : Colors.grey),
                      size: 50,
                    ),
                  );
                }
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
                // Progress Bar Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LVL ${progress.currentLevel}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'LVL ${progress.currentLevel + 1}',
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

  Widget _buildSubscriptionCard({
    required String company,
    required String price,
    required String date,
    required IconData icon,
    required Color color,
    required Color shadowColor,
    required Color statBgColor,
    required Color borderColor,
    required Color textColor,
    required Color primaryColor,
    required Color mutedTextColor,
    String? logoUrl,
    required bool is3D,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 16,
        showBorder: false,
        shadowColor: is3D ? shadowColor : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logoUrl != null && logoUrl.isNotEmpty
              ? BrandLogoAvatar(networkLogoUrl: logoUrl, domain: '', size: 48)
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
          const SizedBox(height: 12),
          Text(
            company,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: mutedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
