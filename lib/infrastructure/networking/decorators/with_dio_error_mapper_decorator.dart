import 'dart:async';

import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';
import 'package:dio/dio.dart';

typedef DecoratedFunction<T> = FutureOr<T> Function();

class WithDioErrorMapperDecorator {
  final DioErrorMapper _dioErrorMapper;

  WithDioErrorMapperDecorator(this._dioErrorMapper);

  FutureOr<T> call<T>(DecoratedFunction<T> fn) async {
    try {
      final result = await fn();
      return result;
    } on DioError catch (e) {
      throw _dioErrorMapper.toFailure(e);
    }
  }
}
