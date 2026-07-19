import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/brand_model.dart';

abstract class BrandRemoteDataSource {
  Future<List<BrandModel>> searchBrands(String query);
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final ApiClient apiClient;

  final LinkedHashMap<String, List<BrandModel>> _cache = LinkedHashMap();
  final int _maxCacheSize = 20;

  BrandRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BrandModel>> searchBrands(String query) async {
    if (_cache.containsKey(query)) {
      return _cache[query]!;
    }

    final response = await apiClient.get(
      'https://autocomplete.clearbit.com/v1/companies/suggest',
      queryParameters: {'query': query},
    );

    if (response.statusCode == 200) {
      try {
        final results = await compute(_parseBrands, response.data);

        if (_cache.length >= _maxCacheSize) {
          _cache.remove(_cache.keys.first);
        }
        _cache[query] = results;

        return results;
      } catch (e) {
        throw ParsingException();
      }
    } else {
      throw ServerException();
    }
  }

  static List<BrandModel> _parseBrands(dynamic data) {
    if (data is List) {
      return data
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
