import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/brand_search_provider.dart';
import 'brand_logo_avatar.dart';

class BrandSearchResults extends ConsumerWidget {
  final Function(String name, String? logoUrl) onSelect;

  const BrandSearchResults({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(brandSearchQueryProvider);
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);

    if (query.trim().length < 3) {
      return const SizedBox.shrink();
    }

    final searchState = ref.watch(brandSearchProvider);

    return searchState.when(
      data: (brands) {
        if (brands.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: Text('Sonuç bulunamadı.')),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          margin: const EdgeInsets.only(top: 16, bottom: 24),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: brands.length > 8 ? 8 : brands.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: borderColor),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return ListTile(
                leading: BrandLogoAvatar(
                  domain: brand.domain,
                  networkLogoUrl: brand.logoUrl,
                  size: 40,
                ),
                title: Text(
                  brand.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(brand.domain),
                onTap: () {
                  onSelect(brand.name, brand.logoUrl);
                },
              );
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
