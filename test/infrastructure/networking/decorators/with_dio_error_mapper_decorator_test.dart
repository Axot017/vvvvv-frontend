import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/failures/network_filures.dart';
import 'package:vvvvv_frontend/infrastructure/networking/decorators/with_dio_error_mapper_decorator.dart';
import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';
import 'package:dio/dio.dart';

import '../../../fallback_values.dart';

class MockedDioErrorMapper extends Mock implements DioErrorMapper {}

void main() {
  late DioErrorMapper _dioErrorMapper;
  late WithDioErrorMapperDecorator _withDioErrorMapper;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    _dioErrorMapper = MockedDioErrorMapper();
    _withDioErrorMapper = WithDioErrorMapperDecorator(_dioErrorMapper);
  });

  test('should return result of function if tehre is no error', () {
    const testResult = 'test result';

    final result = _withDioErrorMapper(() => testResult);

    expect(result, equals(testResult));
    verifyNever(() => _dioErrorMapper.toFailure(any()));
  });

  test('should return async result of function if tehre is no error', () async {
    const testResult = 'test result';

    final result = await _withDioErrorMapper(() async => testResult);

    expect(result, equals(testResult));
    verifyNever(() => _dioErrorMapper.toFailure(any()));
  });

  test('should rethrow error if its not DioError', () async {
    final exception = Exception('test exception');
    try {
      await _withDioErrorMapper(() async {
        throw exception;
      });
    } catch (e) {
      expect(e, equals(exception));
    }
    verifyNever(() => _dioErrorMapper.toFailure(any()));
  });

  test('should map dio exception and throw failure', () async {
    final exception = DioError(requestOptions: RequestOptions(path: ''));
    final failure = ConnectionFailure(Exception(''));
    when(() => _dioErrorMapper.toFailure(any())).thenReturn(failure);

    try {
      _withDioErrorMapper(() {
        throw exception;
      });
    } catch (e) {
      expect(e, equals(failure));
    }
    verify(() => _dioErrorMapper.toFailure(exception)).called(1);
  });
}
