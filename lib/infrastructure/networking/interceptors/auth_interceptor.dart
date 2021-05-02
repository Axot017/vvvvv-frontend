import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/failures/local_storage_failures.dart';
import 'package:vvvvv_frontend/domain/failures/network_filures.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';

const _authHeader = 'auhtorization';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _authLocalDataSource;

  AuthInterceptor(this._authLocalDataSource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _authLocalDataSource.getToken().then((token) {
      if (token != null) {
        options.headers[_authHeader] = token.accessToken;
        handler.next(options);
      } else {
        handler.reject(DioError(
            requestOptions: options,
            error: UnauthenticatedFailure(Exception('No token in storage'))));
      }
    }).catchError((error) {
      if (error is DioError) {
        handler.reject(error..error = LocalStorageReadFailure(error));
      } else {
        handler.reject(DioError(
          error: LocalStorageReadFailure(error),
          requestOptions: options,
        ));
      }
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _authLocalDataSource.clear();
    super.onError(err, handler);
  }
}
