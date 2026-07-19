import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CreatorsPage extends StatelessWidget {
  const CreatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final mutedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final cardBgColor = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final bgColor = theme.scaffoldBackgroundColor;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeIndex = themeProvider.themeIndex;
    String logoPath = 'assets/images/logo.png';
    if (themeIndex == 2) {
      logoPath = 'assets/images/mavi.png';
    } else if (themeIndex == 4) {
      logoPath = 'assets/images/pembe.png';
    } else if (themeIndex == 5) {
      logoPath = 'assets/images/sari.png';
    }

    final creators = [
      {
        'name': 'Arzu HAMDİOĞLU',
        'color': const Color(0xFFf9a8d4),
      }, // açık pembe
      {'name': 'Dicle ÖZKÖK', 'color': const Color(0xFFc4b5fd)}, // açık mor
      {'name': 'Gizem BAĞLAMA', 'color': const Color(0xFF93c5fd)}, // mavi
      {
        'name': 'Yiğit YILDIRIM',
        'color': const Color(0xFFbef264),
      }, // limon yeşili
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          l10n.creators.toUpperCase(),
          style: TextStyle(
            color: mutedColor,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mutedColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: borderColor, height: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              logoPath,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.developersTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 32),

            // Creator cards
            ...creators.map((creator) {
              final color = creator['color'] as Color;
              final name = creator['name'] as String;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: isDark ? 0.6 : 0.45),
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Heart icon — no background
                    Icon(Icons.favorite, color: color, size: 24),
                    const SizedBox(width: 16),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
