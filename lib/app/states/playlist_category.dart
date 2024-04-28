import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/categories.dart';

part 'playlist_category.g.dart';

/// Category state
@riverpod
class PlaylistCategoryNotifier extends _$PlaylistCategoryNotifier {
  /// Current category
  @override
  Category? build() => null;

  /// Previous category
  Category? previousCategory;

  /// Next category
  Category? nextCategory;

  /// Init sync category on categories change
  void init() {
    /// Categories listener
    final categoriesListen =
        ref.listen(asyncCategoriesProvider, (previous, next) {
      if (next.hasValue) {
        /// Sync category
        sync(next.value!);
      }
    });

    /// on dispose
    ref.onDispose(() {
      /// Close listener
      categoriesListen.close();
    });
  }

  /// Set current category
  /// And calculate previous and next
  void setCategory(Category category) {
    /// Set current state
    state = category;

    /// Get cached categories
    final categories =
        ref.read(asyncCategoriesProvider.notifier).cachedCategories;

    /// Get current category index
    final index = categories.indexOf(category);

    /// If index found
    if (index != -1) {
      /// Calculate previous category
      previousCategory = categories

          /// Filter only previous indexes
          .whereIndexed((int whereIndex, _) => whereIndex < index)

          /// Get the last category that has models loaded
          .lastWhereOrNull(
              (Category findCategory) => findCategory.models.isNotEmpty);

      /// Calculate next category
      nextCategory = categories

          /// Filter only next indexes
          .whereIndexed((int whereIndex, _) => whereIndex > index)

          /// Get the first category that has models loaded
          .firstWhereOrNull(
              (Category findCategory) => findCategory.models.isNotEmpty);
    }
  }

  /// Get previous model from category list
  BaseModel? previous(BaseModel model) {
    /// Get mode index
    final index = state!.models.indexOf(model);
    if (index != -1) {
      /// Has previous model in current category
      if (index > 0) {
        /// Return previous model
        return state!.models[index - 1];

        /// Has previous category
      } else if (previousCategory != null) {
        /// Set previous category
        setCategory(previousCategory!);

        /// Return last model from previous category
        return state!.models[state!.models.length - 1];
      }
    }

    /// Don't have previous model
    return null;
  }

  /// Get next model from category list
  BaseModel? next(BaseModel model) {
    /// Get mode index
    final index = state!.models.indexOf(model);

    if (index != -1) {
      /// Has next model in current category
      if (state!.models.length - 1 > index) {
        /// Return next model
        return state!.models[index + 1];

        /// Has next category
      } else if (nextCategory != null) {
        /// Set next category
        setCategory(nextCategory!);

        /// Return first model from next category
        return state!.models[0];
      }
    }

    /// Don't have next model
    return null;
  }

  /// Sync category
  void sync(List<Category> categories) {
    /// If has previous category
    if (previousCategory != null) {
      /// Match category key
      previousCategory = categories.firstWhere(
          (Category category) => category.key == previousCategory!.key);
    }

    /// If has next category
    if (nextCategory != null) {
      nextCategory = categories

          /// Match category key
          .firstWhere((Category category) => category.key == nextCategory!.key);
    }

    /// If has current category
    if (state != null) {
      /// Set current state from the same key
      state = categories

          /// Match category key
          .firstWhere((Category category) => category.key == state!.key);

      /// Update categories
      setCategory(state!);
    }
  }

  /// On close callback
  void onClose() {
    /// Set category to null
    state = null;

    /// Set previous category to null
    previousCategory = null;

    /// Set next category to null
    nextCategory = null;
  }
}
