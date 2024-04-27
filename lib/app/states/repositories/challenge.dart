import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/models/responses/challenges_response.dart';
import 'package:talent_pitch/app/requests/cache.config.dart';
import 'package:talent_pitch/app/requests/request.dart';

class ChallengeRepository {
  Future<List<Challenge>> categoryUrlChallenges(String url) async {
    /// Call challenges API
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
      final challengesResponse = ChallengesResponse.fromJson(response.data!);
      return challengesResponse.data;
    }

    return [];
  }
}
