import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_datasource.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BrandRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BrandEntity>>> searchBrands(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.searchBrands(query);
        return Right(models);
      } on ServerException {
        return Left(ServerFailure('Arama sırasında sunucu hatası oluştu.'));
      } on ParsingException {
        return Left(ServerFailure('Marka verileri okunamadı.'));
      } on NetworkException {
        return Left(NetworkFailure('Bağlantı zaman aşımına uğradı.'));
      }
    } else {
      return Left(NetworkFailure('İnternet bağlantısı yok.'));
    }
  }
}
