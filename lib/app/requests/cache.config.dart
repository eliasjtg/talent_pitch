import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Global options
final globalCacheOptions = CacheOptions(
  store: MemCacheStore(),

  /// Save every successful request.
  policy: CachePolicy.forceCache,

  /// Max stale duration
  maxStale: const Duration(days: 1),
);
