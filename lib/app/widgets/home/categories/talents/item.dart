import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/talent.dart';
import 'package:talent_pitch/app/states/categories.dart';
import 'package:talent_pitch/app/states/playlist.dart';
import 'package:talent_pitch/app/states/repositories/talent.dart';
import 'package:talent_pitch/app/widgets/home/categories/talents/highlighted_image.dart';
import 'package:talent_pitch/app/widgets/home/categories/talents/top_list.dart';

/// Talents item
class TalentsItem extends ConsumerStatefulWidget {
  /// Item [category]
  final Category category;

  /// [talentRepository] instance
  final TalentRepository talentRepository = TalentRepository();

  /// TalentsItem constructor
  TalentsItem({super.key, required this.category});

  @override
  TalentsItemState createState() => TalentsItemState();
}

/// Talents item state
class TalentsItemState extends ConsumerState<TalentsItem>
    with AutomaticKeepAliveClientMixin {
  /// [futureTalents]
  late final Future<List<Talent>> futureTalents;

  @override
  void initState() {
    /// Fetch talents from principal category
    futureTalents =
        widget.talentRepository.categoryUrlTalents(widget.category.url);
    futureTalents.then(
      (List<Talent> talents) => ref
          .read(asyncCategoriesProvider.notifier)

          /// Load models to category
          .setCategoryModels(widget.category, talents),
    );
    super.initState();
  }

  /// On tap talent
  void onTapTalent(int index, Talent talent) {
    ref
        .read(playlistNotifierProvider.notifier)

        /// Set category and current talent
        .setCategory(widget.category, index);

    /// Open viewer
    context
        .pushNamed('/viewer')

        /// Temporal fix to Pop Callback
        .then((value) {
      /// Close playlist on finish view
      ref.read(playlistNotifierProvider.notifier).onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Talent>>(
      future: futureTalents,
      builder: (BuildContext context, AsyncSnapshot<List<Talent>> snapshot) {
        return widget.category.image != null
            ?

            /// Highlight image
            HighlightedImageTalents(
                loading: snapshot.connectionState == ConnectionState.waiting,
                category: widget.category,
                talents: snapshot.data,
                onTap: onTapTalent,
              )
            :

            /// Top list
            TopListTalents(
                loading: snapshot.connectionState == ConnectionState.waiting,
                category: widget.category,
                talents: snapshot.data,
                onTap: onTapTalent,
              );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
