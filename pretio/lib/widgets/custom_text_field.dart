import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final Color? iconColor;
  final String hint;
  final bool isAmount;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.icon,
    this.iconColor,
    required this.hint,
    this.isAmount = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        style: TextStyle(
          fontSize: isAmount ? 20 : 16,
          fontWeight: isAmount ? FontWeight.bold : FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        keyboardType: isAmount ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor ?? Colors.grey[400]),
          suffixIcon: isAmount
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    Provider.of<CurrencyProvider>(context).currency,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: iconColor ?? Colors.grey,
                    ),
                  ),
                )
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
