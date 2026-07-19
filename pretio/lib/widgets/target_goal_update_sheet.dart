import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class TargetGoalUpdateSheet extends StatefulWidget {
  const TargetGoalUpdateSheet({super.key});

  @override
  State<TargetGoalUpdateSheet> createState() => _TargetGoalUpdateSheetState();
}

class _TargetGoalUpdateSheetState extends State<TargetGoalUpdateSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    _nameController.text = provider.shadowGoalName;
    _amountController.text = provider.shadowGoalAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    final name = _nameController.text;
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    if (amount < 0.01) return; // Prevent 0 or negative price

    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).updateShadowGoal(name, amount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final primaryDark = HSLColor.fromColor(primary)
        .withLightness(
          (HSLColor.fromColor(primary).lightness - 0.15).clamp(0.0, 1.0),
        )
        .toColor();
    final textColor = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.goalUpdateGoalTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.goalNameInputLabel,
              labelStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryDark, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.goalTargetPrice,
              suffixText: Provider.of<CurrencyProvider>(context, listen: false).currency,
              labelStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryDark, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            decoration: Provider.of<ThemeProvider>(context).is3DEnabled
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryDark,
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _save,
              child: Text(
                AppLocalizations.of(context)!.goalSaveBtn.toUpperCase(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
