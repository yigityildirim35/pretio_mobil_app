import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/brand_entity.dart';

abstract class BrandRepository {
  Future<Either<Failure, List<BrandEntity>>> searchBrands(String query);
}
