import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
