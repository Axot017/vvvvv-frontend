import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/failures/network_failures.dart';
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
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
    );

    final result = mapper.toFailure(error);

    expect(result, isA<UnknownRequestFailure>());
  });

  test('should return ServerFailure when response code is equal 500 or greater',
      () {
    final requestOptions = RequestOptions(path: '');
    final error = DioError(
      type: DioErrorType.response,
      requestOptions: requestOptions,
      response: Response(
        statusCode: 500,
        requestOptions: requestOptions,
      ),
    );

    final result = mapper.toFailure(error);

    expect(result, isA<ServerFailure>());
  });

  test('should return AuthenticationFailure when response code is equal 401',
      () {
    final requestOptions = RequestOptions(path: '');
    final error = DioError(
      type: DioErrorType.response,
      requestOptions: requestOptions,
      response: Response(
        statusCode: 401,
        requestOptions: requestOptions,
      ),
    );

    final result = mapper.toFailure(error);

    expect(result, isA<AuthenticationFailure>());
  });
  test('should return RequestFailure with mapped body', () {
    final requestOptions = RequestOptions(path: '');
    const testMessage = 'testMessage';
    const testMessageKey = 'error.testMessageKey';
    const testMessageArgs = {'testArg': '1'};
    final error = DioError(
      type: DioErrorType.response,
      requestOptions: requestOptions,
      response: Response(
        statusCode: 400,
        requestOptions: requestOptions,
        data: {
          'message': testMessage,
          'messageKey': testMessageKey,
          'messageArgs': testMessageArgs,
        },
      ),
    );

    final result = mapper.toFailure(error);

    expect(
        result,
        isA<RequestFailure>()
            .having(
              (failure) => failure.messageKey,
              'messageKey',
              equals(testMessageKey),
            )
            .having(
              (failure) => failure.args,
              'args',
              equals(testMessageArgs),
            ));
  });

  test('should return UnknownRequestFailure when body is in unknown format',
      () {
    final requestOptions = RequestOptions(path: '');
    final error = DioError(
      type: DioErrorType.response,
      requestOptions: requestOptions,
      response: Response(
        statusCode: 400,
        requestOptions: requestOptions,
        data: [],
      ),
    );

    final result = mapper.toFailure(error);

    expect(result, isA<UnknownRequestFailure>());
  });
}
