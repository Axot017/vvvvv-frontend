import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/failures/network_filures.dart';
import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';

void main() {
  late DioErrorMapper mapper;

  setUp(() {
    mapper = DioErrorMapper();
  });

  test('should return ConnectionFailure after timeout', () {
    const timeoutTypes = [
      DioErrorType.sendTimeout,
      DioErrorType.connectTimeout,
      DioErrorType.receiveTimeout,
    ];
    final testErrors = timeoutTypes
        .map((e) => DioError(requestOptions: RequestOptions(path: ''), type: e))
        .toList();

    final results = testErrors.map(mapper.toFailure).toList();

    expect(
      results,
      isA<List>().having(
        (e) => e.every((element) => element is ConnectionFailure),
        'type',
        isTrue,
      ),
    );
  });

  test('should return ConnectionFailure after socket exception', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
      error: const SocketException(''),
    );

    final result = mapper.toFailure(error);

    expect(result, isA<ConnectionFailure>());
  });

  test('should return UnknownRequestFailure on unknown "other" dio error', () {
    final error = DioError(requestOptions: RequestOptions(path: ''));

    final result = mapper.toFailure(error);

    expect(result, isA<UnknownRequestFailure>());
  });
}
