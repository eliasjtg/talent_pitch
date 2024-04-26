import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:talent_pitch/app/requests/cache.config.dart';

/// Get dio instance
Dio getDio({
  bool? useBaseUrl = true,
}) {
  /// Setup options
  final BaseOptions options = BaseOptions(
    baseUrl: useBaseUrl == true ? 'https://data2.talentpitch.co/api' : '',
    contentType: ContentType.json.toString(),
  );

  /// Init dio instance
  Dio dio = Dio(options);

  /// Implement interceptors
  dio.interceptors.addAll(<Interceptor>[
    /// Setup cache interceptor
    DioCacheInterceptor(options: globalCacheOptions)
  ]);

  /// Return configured dio instance
  return dio;
}
