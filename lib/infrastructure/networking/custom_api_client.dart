import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/domain/failures/failures.dart';
import 'package:vvvvv_frontend/infrastructure/networking/mappers/dio_error_mapper.dart';

class CustomApiClient implements Dio {
  final Dio dio;
  final DioErrorMapper errorMapper;

  CustomApiClient(this.dio, this.errorMapper);

  Failure _mapError(dynamic error) {
    if (error is DioError) {
      return errorMapper.toFailure(error);
    } else if (error is SocketException) {
      return ConnectionFailure(error);
    } else {
      return Failure(error);
    }
  }

  @override
  HttpClientAdapter get httpClientAdapter => dio.httpClientAdapter;

  @override
  set httpClientAdapter(HttpClientAdapter httpClientAdapter) =>
      dio.httpClientAdapter = httpClientAdapter;

  @override
  BaseOptions get options => dio.options;

  @override
  set options(BaseOptions options) => dio.options = options;

  @override
  Transformer get transformer => dio.transformer;

  @override
  set transformer(Transformer transformer) => dio.transformer = transformer;

  @override
  void clear() {
    dio.clear();
  }

  @override
  void close({bool force = false}) {
    dio.close();
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> deleteUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await dio.deleteUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    try {
      final result = await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response> downloadUri(
    Uri uri,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    try {
      final result = await dio.downloadUri(
        uri,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> fetch<T>(RequestOptions requestOptions) async {
    try {
      final result = await dio.fetch<T>(requestOptions);

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> getUri<T>(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.getUri<T>(
        uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> head<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await dio.head<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> headUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await dio.headUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Interceptors get interceptors => dio.interceptors;

  @override
  void lock() {
    dio.lock();
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> patchUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.patchUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> postUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.postUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> putUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.putUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Response<T>> requestUri<T>(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final result = await dio.requestUri<T>(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return result;
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  void unlock() {
    dio.unlock();
  }
}
