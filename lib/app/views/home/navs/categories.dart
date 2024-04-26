import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/categories.dart';
import 'package:talent_pitch/app/widgets/home/categories/category_item.dart';
import 'package:talent_pitch/app/widgets/card_error.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Category>> categories = ref.watch(categoriesProvider);

    return RefreshIndicator(
      child: categories.when(
          data: (List<Category> categories) => categories.isEmpty
              ? const Center(
                  child: Text('No hay categorias disponibles'),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CategoryItem(category: categories[index]),
                  ),
                ),
          error: (Object error, StackTrace trace) => CardErrorWidget(
                onRetry: () => ref.refresh(categoriesProvider.future),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
      onRefresh: () {
        return ref.refresh(categoriesProvider.future);
      },
    );
  }
}
