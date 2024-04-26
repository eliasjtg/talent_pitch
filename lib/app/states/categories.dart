import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/repositories/categories.dart';

part 'categories.g.dart';

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
@riverpod
Future<List<Category>> categories(CategoriesRef ref) async {
  return CategoriesRepository().listCategories();
}
