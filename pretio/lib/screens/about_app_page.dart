import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

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

    final sections = [
      {
        'icon': Icons.diamond,
        'iconColor': const Color(0xFFf472b6), // pink-400
        'title': l10n.aboutSection1Title,
        'text': l10n.aboutSection1Desc,
      },
      {
        'icon': Icons.self_improvement,
        'iconColor': const Color(0xFF34d399), // emerald-400
        'title': l10n.aboutSection2Title,
        'text': l10n.aboutSection2Desc,
      },
      {
        'icon': Icons.psychology,
        'iconColor': const Color(0xFF60a5fa), // blue-400
        'title': l10n.aboutSection3Title,
        'text': l10n.aboutSection3Desc,
      },
      {
        'icon': Icons.bolt,
        'iconColor': const Color(0xFFfb923c), // orange-400
        'title': l10n.aboutSection4Title,
        'text': l10n.aboutSection4Desc,
      },
      {
        'icon': Icons.palette,
        'iconColor': const Color(0xFFc084fc), // purple-400
        'title': l10n.aboutSection5Title,
        'text': l10n.aboutSection5Desc,
      },
    ];

    const footerColor = Color(0xFF64748b);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          l10n.aboutApp.toUpperCase(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  logoPath,
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 2),
                Text(
                  'Pretio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.aboutHeroDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: mutedColor,
                    height: 1.6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section cards
            ...sections.map((section) {
              final iconColor = section['iconColor'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: isDark ? 0.35 : 0.20),
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section['title'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      section['text'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            // Footer note
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: footerColor.withValues(alpha: isDark ? 0.35 : 0.20),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                l10n.aboutFooterNote,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
