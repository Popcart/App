// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_performance_dio/firebase_performance_dio.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/compressor.dart';
import 'package:popcart/env/env.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'api_helper.freezed.dart';

enum MethodType { get, post, put, delete, patch }

@Freezed()
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({ApiSuccess<T>? data}) = _Success<T>;

  const factory ApiResponse.error(ApiError error) = _Error<T>;
}

@Freezed()
class ListApiResponse<T> with _$ListApiResponse<T> {
  const factory ListApiResponse.success({ListApiSuccess<T>? data}) =
      _ListSuccess<T>;

  const factory ListApiResponse.error(ApiError error) = _ListError<T>;
}

class ApiSuccess<T> {
  ApiSuccess({
    this.message,
    this.status,
    this.data,
    this.accessToken,
  });

  factory ApiSuccess.fromJson(
    Map<String, dynamic> json,
    T? Function(Map<String, dynamic> json)? fromJson,
  ) {
    return ApiSuccess(
      message: (json['message']) as String?,
      status: json['status'] as bool?,
      accessToken: json['access_token'] as String?,
      data: fromJson?.call(json['data'] as Map<String, dynamic>),
    );
  }

  String? message;
  String? accessToken;
  bool? status;
  T? data;

  @override
  String toString() =>
      'ApiSuccess<$T>(message: $message, status: $status, data: $data)';
}

class ListApiSuccess<T> {
  ListApiSuccess({
    this.message,
    this.status,
    this.data,
  });

  factory ListApiSuccess.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return ListApiSuccess(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      data: (json['data'] as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? message;
  bool? status;
  List<T>? data;

  @override
  String toString() =>
      'ListApiSuccess<$T>(message: $message, status: $status, data: $data)';
}

class ApiError {
  ApiError({
    this.message,
    this.code,
    this.error,
  });

  factory ApiError.unknown() => ApiError(message: 'Unknown error occurred');

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as String?,
      code: json['statusCode'] as int?,
      error: json['error'] as String?,
    );
  }

  String? message;
  int? code;

  String? error;

  @override
  String toString() {
    return '''ApiError(message: $message, code: $code)''';
  }
}

class ApiHandler {
  ApiHandler({required String baseUrl}) {
    _dio = dio.Dio(dio.BaseOptions(baseUrl: baseUrl))
      ..options.connectTimeout = const Duration(minutes: 1)
      ..options.receiveTimeout = const Duration(minutes: 1)
      ..options.sendTimeout = const Duration(minutes: 1)
      ..interceptors.add(DioFirebasePerformanceInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          logPrint: (value) {
            if (kDebugMode) {
              log(value.toString(), name: 'Dio');
            }
          },
        ),
      );
  }

  late final dio.Dio _dio;

  void addToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<ApiResponse<T>> request<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T? Function(Map<String, dynamic> json)? responseMapper,
    bool authenticate = true,
    Map<String, File>? files,
  }) async {
    final modifiedPayload = <String, dynamic>{}..addAll(payload ?? {});
    if (files != null) {
      for (final file in files.entries) {
        final compressedFile = await FileCompressor.compressFile(file.value);
        final data = dio.FormData.fromMap({
          'files': await dio.MultipartFile.fromFile(compressedFile.path),
        });
        final uploadInstance = dio.Dio()
          ..interceptors.add(
            PrettyDioLogger(
              requestBody: true,
              requestHeader: true,
              responseHeader: true,
              logPrint: (value) {
                if (kDebugMode) {
                  log(value.toString(), name: 'Dio');
                }
              },
            ),
          );
        final response =
            await uploadInstance.post('${Env().baseUrl}/upload', data: data);
        modifiedPayload[file.key] =
            (response.data['data'] as List<dynamic>).firstOrNull ?? '';
      }
    }
    try {
      if (!authenticate) {
        _dio.options.headers.remove('Authorization');
      } else {
        final token = locator.get<SharedPrefs>().accessToken;
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
      }
      dio.Response<Map<String, dynamic>> response;
      switch (method) {
        case MethodType.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.post:
          response = await _dio.post(
            path,
            data: modifiedPayload,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.put:
          response = await _dio.put(
            path,
            data: modifiedPayload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.delete:
          response = await _dio.delete(
            path,
            data: modifiedPayload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.patch:
          response = await _dio.patch(
            path,
            data: modifiedPayload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
      }
      final successResponse =
          ApiSuccess.fromJson(response.data ?? {}, responseMapper);
      final finalResponse = ApiResponse<T>.success(
        data: successResponse,
      );
      log(finalResponse.toString(), name: 'DioResponse');
      return finalResponse;
    } on dio.DioException catch (e) {
      log('Error: $e', name: 'DioError');
      final error = ApiResponse<T>.error(
        ApiError(
          message: (e.response?.data != null && e.response?.data is Map)
              ? ((e.response?.data as Map)['message']) as String?
              : 'Internal server error',
          error: e.response?.data?['error'] as String?,
        )..code = e.response?.statusCode ?? 500,
      );

      return error;
    } catch (e) {
      log('Error: $e', name: 'DioError');
      // log('StackTrace: $s', name: 'DioError');
      final error = ApiResponse<T>.error(
        ApiError(message: 'Unknown error occurred: $e')..code = 500,
      );
      return error;
    }
  }

  Future<ListApiResponse<T>> requestList<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic> json)? responseMapper,
    bool authenticate = true,
  }) async {
    try {
      if (!authenticate) {
        _dio.options.headers.remove('Authorization');
      } else {
        final token = locator.get<SharedPrefs>().accessToken;
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
      }
      dio.Response<Map<String, dynamic>> response;
      switch (method) {
        case MethodType.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.post:
          response = await _dio.post(
            path,
            data: payload,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.put:
          response = await _dio.put(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.delete:
          response = await _dio.delete(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.patch:
          response = await _dio.patch(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
      }
      final successResponse = ListApiSuccess<T>.fromJson(
        response.data ?? {},
        responseMapper ?? (json) => json as T,
      );
      final finalResponse = ListApiResponse<T>.success(
        data: successResponse,
      );
      log(finalResponse.toString(), name: 'DioResponse');
      return finalResponse;
    } on dio.DioException catch (e) {
      final error = ListApiResponse<T>.error(
        ApiError(
          message: (e.response?.data != null && e.response?.data is Map)
              ? ((e.response?.data as Map)['message']) as String?
              : 'Internal server error',
        )..code = e.response?.statusCode ?? 500,
      );

      return error;
    } catch (e) {
      final error = ListApiResponse<T>.error(
        ApiError(message: 'Unknown error occurred: $e')..code = 500,
      );
      return error;
    }
  }

  Future<T?> custom<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T? Function(Map<String, dynamic> json)? responseMapper,
    bool authenticate = true,
  }) async {
    try {
      if (!authenticate) {
        _dio.options.headers.remove('Authorization');
      } else {
        final token = locator.get<SharedPrefs>().accessToken;
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
      }
      dio.Response<Map<String, dynamic>> response;
      switch (method) {
        case MethodType.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.post:
          response = await _dio.post(
            path,
            data: payload,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.put:
          response = await _dio.put(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.delete:
          response = await _dio.delete(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
        case MethodType.patch:
          response = await _dio.patch(
            path,
            data: payload,
            queryParameters: queryParameters,
            options: dio.Options(
              headers: headers,
            ),
          );
      }
      return responseMapper?.call(response.data ?? {});
    } catch (e) {
      return null;
    }
  }
}
