import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandLogoAvatar extends StatelessWidget {
  final String? networkLogoUrl;
  final String domain;
  final double size;

  const BrandLogoAvatar({
    super.key,
    this.networkLogoUrl,
    required this.domain,
    this.size = 32,
  });

  String _getOptimizedUrl(int requestSize) {
    if (networkLogoUrl == null || networkLogoUrl!.isEmpty) {
      if (domain.isNotEmpty) {
        return 'https://logo.clearbit.com/$domain?size=$requestSize';
      }
      return 'https://www.google.com/s2/favicons?domain=$domain&sz=$requestSize';
    }

    String url = networkLogoUrl!;
    if (url.contains('clearbit.com')) {
      if (url.contains('size=')) {
        url = url.replaceAll(RegExp(r'size=\d+'), 'size=$requestSize');
      } else {
        url += url.contains('?') ? '&size=$requestSize' : '?size=$requestSize';
      }
    } else if (url.contains('google.com/s2/favicons')) {
      if (url.contains('sz=')) {
        url = url.replaceAll(RegExp(r'sz=\d+'), 'sz=$requestSize');
      } else {
        url += url.contains('?') ? '&sz=$requestSize' : '?sz=$requestSize';
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Calculate device pixel ratio for retina displays
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // 2. Calculate exact physical pixels needed
    final int physicalPixels = (size * pixelRatio).ceil();

    // 3. Bucket requests to standard sizes (improves CDN hit rate)
    int requestSize = 128;
    if (physicalPixels > 128) requestSize = 256;
    if (physicalPixels > 256) requestSize = 512;

    final String targetUrl = _getOptimizedUrl(requestSize);
    final String fallbackUrl =
        'https://www.google.com/s2/favicons?domain=$domain&sz=$requestSize';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFFF8FAFC),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: targetUrl,
        fit: BoxFit.contain,
        filterQuality:
            FilterQuality.medium, // High can cause frame drops on scroll
        memCacheWidth: physicalPixels, // STRICT MEMORY BOUND (prevents OOM)
        memCacheHeight: physicalPixels,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl: fallbackUrl,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          memCacheWidth: physicalPixels,
          memCacheHeight: physicalPixels,
          errorWidget: (context, url, error) => Center(
            child: Icon(
              Icons.business,
              size: size * 0.6,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
