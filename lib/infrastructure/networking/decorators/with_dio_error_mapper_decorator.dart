import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';
import 'package:dio/dio.dart';

class WithDioErrorMapperDecorator {
  final DioErrorMapper _dioErrorMapper;

  WithDioErrorMapperDecorator(this._dioErrorMapper);

  T call<T>(T Function() fn) {
    try {
      return fn();
    } on DioError catch (e) {
      throw _dioErrorMapper.toFailure(e);
    } catch (e) {
      rethrow;
    }
  }
}
