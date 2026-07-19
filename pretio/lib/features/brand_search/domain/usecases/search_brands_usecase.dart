import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class SearchBrandsUseCase {
  final BrandRepository repository;

  SearchBrandsUseCase(this.repository);

  Future<Either<Failure, List<BrandEntity>>> execute(String query) async {
    final sanitizedQuery = query.trim();
    if (sanitizedQuery.length < 3) {
      return const Right([]);
    }
    return await repository.searchBrands(sanitizedQuery);
  }
}
