import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:talent_pitch/app/models/company.dart';
import 'package:talent_pitch/app/models/responses/companies_response.dart';
import 'package:talent_pitch/app/requests/cache.config.dart';
import 'package:talent_pitch/app/requests/request.dart';

class CompanyRepository {
  Future<List<Company>> categoryUrlCompanies(String url) async {
    /// Call companies API
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
      final companiesResponse = CompaniesResponse.fromJson(response.data!);
      return companiesResponse.data;
    }

    return [];
  }
}
