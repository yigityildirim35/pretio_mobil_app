import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class TimeCostItem extends StatelessWidget {
  final String name;
  final double price; // Base Currency (TRY)
  final IconData icon;
  final Color color;
  final String workTime;

  const TimeCostItem({
    super.key,
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
    required this.workTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    // Convert & Format Price
    final displayPrice = currencyProvider.getDisplayValue(price);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  displayPrice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                workTime,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Text(
                'of work',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
