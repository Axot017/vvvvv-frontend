import 'dart:async';

import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';
import 'package:dio/dio.dart';

class WithDioErrorMapperDecorator {
  final DioErrorMapper _dioErrorMapper;

  WithDioErrorMapperDecorator(this._dioErrorMapper);

  FutureOr<T> call<T>(FutureOr<T> Function() fn) async {
    try {
      final result = await fn();
      return result;
    } on DioError catch (e) {
      throw _dioErrorMapper.toFailure(e);
    } catch (e) {
      rethrow;
    }
  }
}
