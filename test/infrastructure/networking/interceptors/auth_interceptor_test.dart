import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/failures/local_storage_failures.dart';
import 'package:vvvvv_frontend/domain/failures/network_failures.dart';
import 'package:vvvvv_frontend/infrastructure/networking/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/utils/current_date_provider.dart';

import '../../../fallback_values.dart';

abstract class LockFunction {
  void call();
}

class MockedAuthInteractor extends Mock implements AuthInteractor {}

class MockedRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockedErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockedCurrentDateProvider extends Mock implements CurrentDateProvider {}

class MockedDioLock extends Mock implements LockFunction {}

void main() {
  late RequestInterceptorHandler requestInterceptorHandler;
  late ErrorInterceptorHandler errorInterceptorHandler;
  late CurrentDateProvider currentDateProvider;
  late AuthInteractor authInteractor;
  late LockFunction lockDio;
  late LockFunction unlockDio;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    requestInterceptorHandler = MockedRequestInterceptorHandler();
    errorInterceptorHandler = MockedErrorInterceptorHandler();
    authInteractor = MockedAuthInteractor();
    currentDateProvider = MockedCurrentDateProvider();
    lockDio = MockedDioLock();
    unlockDio = MockedDioLock();
    interceptor = AuthInterceptor(
      authInteractor,
      currentDateProvider,
      lockDio,
      unlockDio,
    );
  });

  group('onRequest', () {
    test('should call next interceptor when there is no token in storage',
        () async {
      when(() => authInteractor.getTokensPair())
          .thenAnswer((_) => Future.value());

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );
      await untilCalled(() => authInteractor.getTokensPair());

      verify(() => authInteractor.getTokensPair()).called(1);
      verify(
        () => requestInterceptorHandler.next(
          any(
            that: isA<RequestOptions>().having(
              (options) => options.headers['Authorization'],
              'authorization header',
              null,
            ),
          ),
        ),
      ).called(1);
      verifyNever(() => currentDateProvider.getCurrentDate());
    });

    test('should add token from local storege request options if it is valid',
        () async {
      const testAccessToken = 'testAccessToken';
      when(() => currentDateProvider.getCurrentDate())
          .thenReturn(DateTime(2030));
      when(() => authInteractor.getTokensPair()).thenAnswer(
        (_) => Future.value(
          TokensPair(
            accessToken: testAccessToken,
            accessTokenExpirationDate: DateTime(2050),
            refreshToken: '',
            refreshTokenExpiretionDate: DateTime(2100),
          ),
        ),
      );

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      await untilCalled(() => authInteractor.getTokensPair());
      await Future.delayed(Duration.zero);

      verify(() => authInteractor.getTokensPair()).called(1);
      verify(
        () => requestInterceptorHandler.next(
          any(
            that: isA<RequestOptions>().having(
              (options) => options.headers['Authorization'],
              'authorization header',
              equals(testAccessToken),
            ),
          ),
        ),
      ).called(1);
      verify(() => currentDateProvider.getCurrentDate()).called(1);
      verifyNever(() => authInteractor.refreshToken(any()));
    });

    test('should refresh token if current is expired', () async {
      final currentToken = TokensPair(
        accessToken: 'testAccessToken',
        accessTokenExpirationDate: DateTime(2050),
        refreshToken: 'testRefreshToken',
        refreshTokenExpiretionDate: DateTime(2100),
      );
      final newToken = TokensPair(
        accessToken: 'testAccessToken2',
        accessTokenExpirationDate: DateTime(2150),
        refreshToken: 'testRefreshToken2',
        refreshTokenExpiretionDate: DateTime(2200),
      );
      when(() => currentDateProvider.getCurrentDate()).thenReturn(
        DateTime(2075),
      );
      when(() => authInteractor.getTokensPair()).thenAnswer(
        (_) => Future.value(currentToken),
      );
      when(() => authInteractor.refreshToken(any())).thenAnswer(
        (_) => Future.value(newToken),
      );

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );
      await untilCalled(() => authInteractor.getTokensPair());
      await Future.delayed(Duration.zero);

      verify(() => authInteractor.getTokensPair()).called(1);
      verify(
        () => requestInterceptorHandler.next(
          any(
            that: isA<RequestOptions>().having(
              (options) => options.headers['Authorization'],
              'authorization header',
              equals(newToken.accessToken),
            ),
          ),
        ),
      ).called(1);
      verify(() => currentDateProvider.getCurrentDate()).called(1);
      verify(() => authInteractor.refreshToken(currentToken)).called(1);
      verify(() => lockDio()).called(1);
      verify(() => unlockDio()).called(1);
    });

    test('should reject after local storage read error', () async {
      when(() => authInteractor.getTokensPair())
          .thenAnswer((_) => Future.error(Exception('Some error')));

      interceptor.onRequest(
        RequestOptions(path: ''),
        requestInterceptorHandler,
      );

      await untilCalled(() => authInteractor.getTokensPair());

      verify(
        () => requestInterceptorHandler.reject(
          any(
            that: isA<DioError>().having(
              (e) => e.error,
              'error',
              isA<LocalStorageReadFailure>(),
            ),
          ),
        ),
      ).called(1);
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
