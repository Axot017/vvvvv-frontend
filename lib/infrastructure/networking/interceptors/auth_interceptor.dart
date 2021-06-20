import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/failures/local_storage_failures.dart';
import 'package:vvvvv_frontend/domain/failures/network_failures.dart';
import 'package:vvvvv_frontend/utils/current_date_provider.dart';

const _authHeader = 'Authorization';

class AuthInterceptor extends Interceptor {
  final AuthInteractor _authInteractor;
  final CurrentDateProvider _currentDateProvider;
  final void Function() _lockDio;
  final void Function() _unlockDio;

  AuthInterceptor(
    this._authInteractor,
    this._currentDateProvider,
    this._lockDio,
    this._unlockDio,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _handleRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.error is AuthenticationFailure) {
      _authInteractor.logout();
    }
    super.onError(err, handler);
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final tokensPair = await _authInteractor.getTokensPair();

      if (tokensPair != null) {
        await _addAuthHeader(options, tokensPair);
      }
      handler.next(options);
    } catch (e) {
      handler.reject(DioError(
        error: LocalStorageReadFailure(e),
        requestOptions: options,
      ));
    }
  }

  Future<void> _addAuthHeader(
    RequestOptions options,
    TokensPair tokensPair,
  ) async {
    if (_isTokenValid(tokensPair)) {
      options.headers[_authHeader] = tokensPair.accessToken;
    } else {
      try {
        _lockDio();
        final newToken = await _authInteractor.refreshToken(tokensPair);
        options.headers[_authHeader] = newToken.accessToken;
      } finally {
        _unlockDio();
      }
    }
  }

  bool _isTokenValid(TokensPair tokensPair) {
    final validUntil = tokensPair.accessTokenExpirationDate;
    final currentDate = _currentDateProvider.getCurrentDate();

    return currentDate.isBefore(validUntil);
  }
}
