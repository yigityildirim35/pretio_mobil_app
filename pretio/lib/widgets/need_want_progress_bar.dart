import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';

class NeedWantProgressBar extends StatelessWidget {
  final double needsAmount;
  final double wantsAmount;
  final double necessityAmount;

  const NeedWantProgressBar({
    super.key,
    required this.needsAmount,
    required this.wantsAmount,
    required this.necessityAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = Provider.of<CurrencyProvider>(context).currency;
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final total = needsAmount + wantsAmount + necessityAmount;

    // Avoid division by zero
    double needsPct = 0.0;
    double wantsPct = 0.0;
    double necessityPct = 0.0;

    if (total > 0) {
      needsPct = (needsAmount / total).clamp(0.0, 1.0);
      wantsPct = (wantsAmount / total).clamp(0.0, 1.0);
      necessityPct = (necessityAmount / total).clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(context: context, is3D: is3D),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.balance,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.spendingBalance,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // NEEDS Label
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.needs.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Subtle Grey
                    ),
                  ),
                  Text(
                    '${(needsPct * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 20, // High contrast
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled
                        ? '***'
                        : '${needsAmount.toInt()} $currency',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
              // NECESSITY Label (Zorunluluk)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.necessity.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Subtle Grey
                    ),
                  ),
                  Text(
                    '${(necessityPct * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 20, // High contrast
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled
                        ? '***'
                        : '${necessityAmount.toInt()} $currency',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
              // WANTS Label
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.wants.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Subtle Grey
                    ),
                  ),
                  Text(
                    '${(wantsPct * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 20, // High contrast
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled
                        ? '***'
                        : '${wantsAmount.toInt()} $currency',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Fully rounded ends
            child: SizedBox(
              height: 16, // Slightly thicker
              child: Row(
                children: [
                  if (needsPct > 0)
                    Expanded(
                      flex: (needsPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF26E581), // Vibrant Green
                          border: Border.all(
                            color: const Color(0xFF26E581),
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: is3D ? _build3DBarHighlight() : null,
                      ),
                    ),
                  if (necessityPct > 0)
                    Expanded(
                      flex: (necessityPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B), // Coral Red
                          border: Border.all(
                            color: const Color(0xFFFF6B6B),
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: is3D ? _build3DBarHighlight() : null,
                      ),
                    ),
                  if (wantsPct > 0)
                    Expanded(
                      flex: (wantsPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B39ED), // Deep Purple
                          border: Border.all(
                            color: const Color(0xFF7B39ED),
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: is3D ? _build3DBarHighlight() : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DBarHighlight() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.35),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
