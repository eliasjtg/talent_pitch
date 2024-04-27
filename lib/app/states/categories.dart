import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/repositories/categories.dart';

part 'categories.g.dart';

@riverpod
class AsyncCategories extends _$AsyncCategories {
  @override
  FutureOr<List<Category>> build() async {
    return CategoriesRepository().listCategories();
  }

  /// Cached categories
  List<Category> cachedCategories = [];

  Future<void> setCategoryModels(
      Category category, List<BaseModel> models) async {
    final index = state.value?.indexOf(category);
    if (index != -1) {
      final categories = List<Category>.from(state.value!);
      categories[index!] = category.copyWith(
        models: models,
      );
      state = await AsyncValue.guard(() async {
        return categories;
      });
    }
  }

  @override
  bool updateShouldNotify(AsyncValue<List<Category>> previous, AsyncValue<List<Category>> next) {
    if(next.hasValue) {
      cachedCategories = next.value!;
    }
    return super.updateShouldNotify(previous, next);
  }
}
