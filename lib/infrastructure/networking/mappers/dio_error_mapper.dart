import 'dart:io';

import 'package:vvvvv_frontend/domain/failures/failure.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/failures/network_filures.dart';
import 'package:vvvvv_frontend/infrastructure/networking/dtos/request_error_dto.dart';

const _timeoutErrors = [
  DioErrorType.sendTimeout,
  DioErrorType.connectTimeout,
  DioErrorType.receiveTimeout,
];

class DioErrorMapper {
  Failure toFailure(DioError dioError) {
    if (dioError.type == DioErrorType.response) {
      return _mapResponseError(dioError);
    } else if (_timeoutErrors.contains(dioError.type)) {
      return ConnectionFailure(dioError);
    } else {
      if (dioError.error is SocketException) {
        return ConnectionFailure(dioError);
      }
      return UnknownRequestFailure(dioError);
    }
  }

  Failure _mapResponseError(DioError dioError) {
    if ((dioError.response?.statusCode ?? 500) >= 500) {
      return ServerFailure(dioError);
    } else if (dioError.response?.statusCode == HttpStatus.unauthorized) {
      return AuthenticationFailure(dioError);
    } else if (dioError.response?.statusCode == HttpStatus.forbidden) {
      return UnauthenticatedFailure(dioError);
    } else {
      final data = dioError.response?.data as Map<String, dynamic>?;

      if (data == null) {
        return UnknownRequestFailure(dioError);
      }

      final responseError = RequestErrorDto.fromJson(data);

      return RequestFailure(
        dioError,
        messageKey: responseError.messageKey,
        args: responseError.messageArgs,
      );
    }
  }
}
