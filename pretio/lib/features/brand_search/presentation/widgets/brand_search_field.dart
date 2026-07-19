import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/brand_search_provider.dart';

class BrandSearchField extends ConsumerStatefulWidget {
  const BrandSearchField({super.key});

  @override
  ConsumerState<BrandSearchField> createState() => _BrandSearchFieldState();
}

class _BrandSearchFieldState extends ConsumerState<BrandSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: borderColor,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
      ),
      child: TextField(
        controller: _controller,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: 'Abonelik ara (örn. Netflix)...',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: mutedColor,
          ),
          prefixIcon: Icon(Icons.search, color: mutedColor),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: mutedColor),
                  onPressed: () {
                    _controller.clear();
                    ref.read(brandSearchQueryProvider.notifier).setQuery('');
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: cardBgColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        onChanged: (value) {
          ref.read(brandSearchQueryProvider.notifier).setQuery(value);
          setState(() {});
        },
      ),
    );
  }
}
