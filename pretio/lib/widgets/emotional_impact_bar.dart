import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';
import 'package:provider/provider.dart';

class EmotionalImpactBar extends StatelessWidget {
  final int happyCount;
  final int neutralCount;
  final int regretCount;

  const EmotionalImpactBar({
    super.key,
    required this.happyCount,
    required this.neutralCount,
    required this.regretCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final total = happyCount + neutralCount + regretCount;

    double happyPct = 0;
    double neutralPct = 0;
    double regretPct = 0;

    if (total > 0) {
      happyPct = happyCount / total;
      neutralPct = neutralCount / total;
      regretPct = regretCount / total;
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
                  color: Colors.pink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite, color: Colors.pink, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.emotionalImpact,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel(
                context,
                AppLocalizations.of(context)!.good,
                happyPct,
                Theme.of(context).colorScheme.primary,
              ),
              _buildLabel(
                context,
                AppLocalizations.of(context)!.okay,
                neutralPct,
                Theme.of(context).colorScheme.tertiary,
              ),
              _buildLabel(
                context,
                AppLocalizations.of(context)!.regret,
                regretPct,
                Theme.of(context).colorScheme.error,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  if (happyPct > 0)
                    Expanded(
                      flex: (happyPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: is3D ? _build3DBarHighlight() : null,
                      ),
                    ),
                  if (neutralPct > 0)
                    Expanded(
                      flex: (neutralPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: is3D ? _build3DBarHighlight() : null,
                      ),
                    ),
                  if (regretPct > 0)
                    Expanded(
                      flex: (regretPct * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error,
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
          height: 8,
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

  Widget _buildLabel(
    BuildContext context,
    String label,
    double pct,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(pct * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
