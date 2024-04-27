import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/categories.dart';

part 'playlist_category.g.dart';

@riverpod
class PlaylistCategoryNotifier extends _$PlaylistCategoryNotifier {
  @override
  Category? build() => null;

  Category? previousCategory;
  Category? nextCategory;

  void setCategory(Category category) {
    state = category;
    final categories = ref.read(asyncCategoriesProvider.notifier).cachedCategories;
    final index = categories.indexOf(category);
    if (index != -1) {
      previousCategory = categories
          .whereIndexed((int whereIndex, _) => whereIndex < index)
          .lastWhereOrNull((Category findCategory) => findCategory.models.isNotEmpty);
      nextCategory = categories
          .whereIndexed((int whereIndex, _) => whereIndex > index)
          .firstWhereOrNull((Category findCategory) => findCategory.models.isNotEmpty);
    }
  }

  BaseModel? previous(BaseModel model) {
    final index = state!.models.indexOf(model);
    if (index != -1) {
      /// Remaining index
      if (index > 0) {
        /// Previous
        return state!.models[index - 1];

        /// Previous category
      } else if (previousCategory != null) {
        /// Set at end
        setCategory(previousCategory!);
        return state!.models[state!.models.length - 1];
      }
    }

    return null;
  }

  BaseModel? next(BaseModel model) {
    final index = state!.models.indexOf(model);

    if (index != -1) {
      /// Remaining index
      if (state!.models.length - 1 > index) {
        /// Next
        return state!.models[index + 1];

        /// Next category
      } else if (nextCategory != null) {
        /// Set at start
        setCategory(nextCategory!);
        return state!.models[0];
      }
    }

    return null;
  }

  void sync(List<Category> categories) {
    if(previousCategory != null) {
      previousCategory = categories.firstWhere((Category category) => category.key == previousCategory!.key);
    }
    if(nextCategory != null) {
      nextCategory = categories.firstWhere((Category category) => category.key == nextCategory!.key);
    }
    if(state != null) {
      state = categories.firstWhere((Category category) => category.key == state!.key);
      setCategory(state!);
    }
  }

  void init() {
    final categoriesListen =
      ref.listen(asyncCategoriesProvider, (previous, next) {
      if (next.hasValue) {
        sync(next.value!);
      }
    });
    ref.onDispose(() {
      categoriesListen.close();
    });
  }

  void onClose() {
    state = null;
    previousCategory = null;
    nextCategory = null;
  }
}
