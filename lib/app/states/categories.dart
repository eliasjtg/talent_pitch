import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/repositories/categories.dart';

part 'categories.g.dart';

/// Principal categories state
@riverpod
class AsyncCategories extends _$AsyncCategories {
  /// Build state fetching categories from API
  @override
  FutureOr<List<Category>> build() async {
    return CategoriesRepository().listCategories();
  }

  /// Cached categories
  List<Category> cachedCategories = [];

  /// Load models into category
  Future<void> setCategoryModels(
      Category category, List<BaseModel> models) async {
    /// Get category index
    final index = state.value?.indexOf(category);

    /// If category found
    if (index != -1) {
      /// Mutable list from state
      final categories = List<Category>.from(state.value!);

      /// Load models to category
      categories[index!] = category.copyWith(
        models: models,
      );

      /// Update state
      state = await AsyncValue.guard(() async {
        return categories;
      });
    }
  }

  /// Set cachedCategories on change state
  @override
  bool updateShouldNotify(
      AsyncValue<List<Category>> previous, AsyncValue<List<Category>> next) {
    if (next.hasValue) {
      /// Update cached categories
      cachedCategories = next.value!;
    }

    /// Return parent value
    return super.updateShouldNotify(previous, next);
  }
}
