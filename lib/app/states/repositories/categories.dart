import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/responses/categories_response.dart';
import 'package:talent_pitch/app/requests/cache.config.dart';
import 'package:talent_pitch/app/requests/request.dart';

class CategoriesRepository {
  /// Fetch categories from API
  Future<List<Category>> listCategories() async {
    /// Call categories API
    final response = await get(
      '/homeservice/categories/all/12',
      options: globalCacheOptions
          .copyWith(
            policy: CachePolicy.refresh,
          )
          .toOptions(),
    );

    if (response.data != null) {
      final categoriesResponse = CategoriesResponse.fromJson(response.data!);
      return categoriesResponse.data;
    }

    return [];
  }
}
