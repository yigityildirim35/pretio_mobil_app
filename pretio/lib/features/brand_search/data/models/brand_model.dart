import '../../domain/entities/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({required super.name, required super.domain, super.logoUrl});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final domain = json['domain'] as String;
    String? finalLogoUrl = json['logo'] as String?;

    // Request higher resolution image from clearbit
    if (finalLogoUrl != null && finalLogoUrl.contains('clearbit.com')) {
      finalLogoUrl += '?size=512';
    }

    finalLogoUrl ??= 'https://icon.horse/icon/$domain';

    return BrandModel(
      name: json['name'] as String,
      domain: domain,
      logoUrl: finalLogoUrl,
    );
  }
}
