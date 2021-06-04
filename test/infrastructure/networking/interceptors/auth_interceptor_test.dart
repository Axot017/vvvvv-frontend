import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/failures/local_storage_failures.dart';
import 'package:vvvvv_frontend/domain/failures/network_filures.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/networking/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';

import '../../../fallback_values.dart';

class MockedAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockedAuthInteractor extends Mock implements AuthInteractor {}

class MockedRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockedErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late AuthLocalDataSource localDataSource;
  late RequestInterceptorHandler requestInterceptorHandler;
  late ErrorInterceptorHandler errorInterceptorHandler;
  late AuthInteractor authInteractor;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    requestInterceptorHandler = MockedRequestInterceptorHandler();
    errorInterceptorHandler = MockedErrorInterceptorHandler();
    authInteractor = MockedAuthInteractor();
    localDataSource = MockedAuthLocalDataSource();
    interceptor = AuthInterceptor(localDataSource, authInteractor);
  });

  group('onRequest', () {
    test('should get token from local storage', () async {
      when(() => localDataSource.getToken())
          .thenAnswer((_) => Future.value(null));

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      verify(() => localDataSource.getToken()).called(1);
    });

    test('should call next interceptor after getting token from local storage',
        () async {
      when(() => localDataSource.getToken())
          .thenAnswer((_) => Future.value(null));

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      await untilCalled(() => localDataSource.getToken());

      verify(() => requestInterceptorHandler.next(any())).called(1);
    });

    test('should add token from local storege request options', () async {
      const testAccessToken = 'testAccessToken';
      when(() => localDataSource.getToken())
          .thenAnswer((_) => Future.value(TokensPairDao(
                accessToken: testAccessToken,
                accessTokenExpirationDate: DateTime(1990),
                refreshToken: '',
                refreshTokenExpiretionDate: DateTime(1990),
              )));

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      await untilCalled(() => localDataSource.getToken());

      verify(() => requestInterceptorHandler.next(
            any(
              that: isA<RequestOptions>().having(
                (options) => options.headers['Authorization'],
                'authorization header',
                equals(testAccessToken),
              ),
            ),
          )).called(1);
    });

    test('should reject after local storage read error', () async {
      when(() => localDataSource.getToken())
          .thenAnswer((_) => Future.error(Exception('Some error')));

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      await untilCalled(() => localDataSource.getToken());

      verify(() => requestInterceptorHandler.reject(any(
            that: isA<DioError>().having(
              (e) => e.error,
              'error',
              isA<LocalStorageReadFailure>(),
            ),
          ))).called(1);
    });
  });

  group('onError', () {
    test('should call logout when authentication error occurs', () async {
      final error = DioError(
        requestOptions: RequestOptions(path: ''),
        error: AuthenticationFailure(Exception()),
      );
      when(() => authInteractor.logout()).thenAnswer((_) => Future.value());

      interceptor.onError(error, errorInterceptorHandler);

      verify(() => authInteractor.logout()).called(1);
      verify(() => errorInterceptorHandler.next(any())).called(1);
    });

    test('should not call logout when request error occurs', () async {
      final error = DioError(
        requestOptions: RequestOptions(path: ''),
        error: UnknownRequestFailure(Exception()),
      );
      when(() => authInteractor.logout()).thenAnswer((_) => Future.value());

      interceptor.onError(error, errorInterceptorHandler);

      verifyNever(() => authInteractor.logout());
      verify(() => errorInterceptorHandler.next(any())).called(1);
    });
  });
}
