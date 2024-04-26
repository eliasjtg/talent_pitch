import 'package:dio/dio.dart';
import 'package:talent_pitch/app/requests/dio.dart';

/// Request GET
Future<Response<Map<String, dynamic>>> get(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  bool? useBaseUrl = true,
}) async {
  final Dio dio = getDio(useBaseUrl: useBaseUrl);

  return dio.get<Map<String, dynamic>>(
    url,
    queryParameters: parameters,
    options: options,
  );
}
