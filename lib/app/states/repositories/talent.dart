import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:talent_pitch/app/models/responses/talents_response.dart';
import 'package:talent_pitch/app/models/talent.dart';
import 'package:talent_pitch/app/requests/cache.config.dart';
import 'package:talent_pitch/app/requests/request.dart';

class TalentRepository {
  /// Fetch talents from API
  Future<List<Talent>> categoryUrlTalents(String url) async {
    /// Call categories API
    final response = await get(
      url,
      useBaseUrl: false,
      options: globalCacheOptions
          .copyWith(
            policy: CachePolicy.refresh,
          )
          .toOptions(),
    );

    if (response.data != null) {
      final talentsResponse = TalentsResponse.fromJson(response.data!);
      return talentsResponse.data;
    }

    return [];
  }
}
