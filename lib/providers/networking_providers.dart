import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:vvvvv_frontend/config/general_config.dart';
import 'package:vvvvv_frontend/infrastructure/networking/decorators/with_dio_error_mapper_decorator.dart';
import 'package:vvvvv_frontend/infrastructure/networking/interceptors/auth_interceptor.dart';
import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';
import 'package:vvvvv_frontend/providers/auth_providers.dart';

final unauthenticatedDioProvider = Provider<Dio>((ref) {
  final dioLogger = ref.watch(_dioLoggerProvider);

  final dio = Dio(BaseOptions(
    baseUrl: GeneralConfig.baseUrl,
  ));

  _addLogger(dioLogger, dio);

  return dio;
});

final authenticatedDioProvider = Provider<Dio>((ref) {
  final authInterceptor = ref.watch(_authInterceptorProvider);
  final dioLogger = ref.watch(_dioLoggerProvider);

  final dio = Dio(BaseOptions(
    baseUrl: GeneralConfig.baseUrl,
  ));

  _addLogger(dioLogger, dio);
  dio.interceptors.add(authInterceptor);

  return dio;
});

final withDioErrorMapperDecoretorProvider =
    Provider<WithDioErrorMapperDecorator>((ref) {
  final dioErrorMapper = ref.watch(_dioErrorMapperProvider);
  return WithDioErrorMapperDecorator(dioErrorMapper);
});

final _authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final authInteractor = ref.watch(authInteractorProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthInterceptor(authLocalDataSource, authInteractor);
});

final _dioErrorMapperProvider = Provider<DioErrorMapper>((ref) {
  return DioErrorMapper();
});

final _dioLoggerProvider = Provider<PrettyDioLogger>((ref) {
  return PrettyDioLogger();
});

void _addLogger(PrettyDioLogger logger, Dio dio) {
  assert(() {
    dio.interceptors.add(logger);

    return true;
  }());
}
