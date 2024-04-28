import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/categories.dart';
import 'package:talent_pitch/app/states/playlist.dart';
import 'package:talent_pitch/app/states/playlist_category.dart';
import 'package:talent_pitch/app/states/video.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talent_pitch/app/widgets/home/categories/category_item.dart';
import 'package:talent_pitch/app/widgets/card_error.dart';

/// Categories section
class CategoriesSection extends ConsumerStatefulWidget {
  /// CategoriesSection constructor
  const CategoriesSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CategoriesSectionState();
}

/// Categories section state
class CategoriesSectionState extends ConsumerState<CategoriesSection> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// Init category state
      ref.read(playlistCategoryNotifierProvider.notifier).init();

      /// Init video state
      ref.read(videoNotifierProvider.notifier).init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Keep alive states
    ref
      ..watch(playlistNotifierProvider)
      ..watch(playlistCategoryNotifierProvider)
      ..watch(videoNotifierProvider);

    /// Principal categories
    final AsyncValue<List<Category>> categories =
        ref.watch(asyncCategoriesProvider);

    return categories.when(
      data: (List<Category> categories) => categories.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.no_categories_available,
              ),
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
        onRetry: () => ref.refresh(asyncCategoriesProvider.future),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
