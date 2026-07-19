import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info_impl.dart';
import '../../data/datasources/brand_remote_datasource.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/usecases/search_brands_usecase.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(Dio());
});

final networkInfoProvider = Provider<NetworkInfoImpl>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final brandRemoteDataSourceProvider = Provider<BrandRemoteDataSource>((ref) {
  return BrandRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final brandRepositoryProvider = Provider<BrandRepositoryImpl>((ref) {
  return BrandRepositoryImpl(
    remoteDataSource: ref.watch(brandRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final searchBrandsUseCaseProvider = Provider<SearchBrandsUseCase>((ref) {
  return SearchBrandsUseCase(ref.watch(brandRepositoryProvider));
});

// State Management
class BrandSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final brandSearchQueryProvider =
    NotifierProvider<BrandSearchQueryNotifier, String>(
      BrandSearchQueryNotifier.new,
    );

final brandSearchProvider = FutureProvider.autoDispose<List<BrandEntity>>((
  ref,
) async {
  final query = ref.watch(brandSearchQueryProvider);

  if (query.trim().length < 3) return [];

  // Debouncing logic
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  await Future.delayed(const Duration(milliseconds: 500));

  if (didDispose) throw Exception('Cancelled');

  final useCase = ref.watch(searchBrandsUseCaseProvider);
  final result = await useCase.execute(query);

  return result.fold((failure) => throw failure.message, (brands) => brands);
});
