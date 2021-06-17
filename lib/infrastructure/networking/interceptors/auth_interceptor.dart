import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/failures/local_storage_failures.dart';
import 'package:vvvvv_frontend/domain/failures/network_failures.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';

const _authHeader = 'Authorization';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthInteractor _authInteractor;

  AuthInterceptor(this._authLocalDataSource, this._authInteractor);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _authLocalDataSource.getToken().then((token) {
      if (token != null) {
        options.headers[_authHeader] = token.accessToken;
      }
      handler.next(options);
    }).catchError((error) {
      handler.reject(DioError(
        error: LocalStorageReadFailure(error),
        requestOptions: options,
      ));
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.error is AuthenticationFailure) {
      _authInteractor.logout();
    }
    super.onError(err, handler);
  }
}
