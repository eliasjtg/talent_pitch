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

class TalentsItem extends ConsumerStatefulWidget {
  /// Item [category]
  final Category category;

  /// [talentRepository]
  final TalentRepository talentRepository = TalentRepository();

  TalentsItem({super.key, required this.category});

  @override
  TalentsItemState createState() => TalentsItemState();
}

class TalentsItemState extends ConsumerState<TalentsItem>
    with AutomaticKeepAliveClientMixin {
  late final Future<List<Talent>> futureTalents;

  @override
  void initState() {
    futureTalents =
        widget.talentRepository.categoryUrlTalents(widget.category.url);
    futureTalents.then(
      (List<Talent> talents) => ref
          .read(asyncCategoriesProvider.notifier)
          .setCategoryModels(widget.category, talents),
    );
    super.initState();
  }

  void onTapTalent(int index, Talent talent) {
    ref
        .read(playlistNotifierProvider.notifier)
        .setCategory(widget.category, index);
    context
        .pushNamed('/viewer')

        /// Temporal fix to Pop Callback
        .then((value) {
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
            ? HighlightedImageTalents(
                loading: snapshot.connectionState == ConnectionState.waiting,
                category: widget.category,
                talents: snapshot.data,
                onTap: onTapTalent,
              )
            : TopListTalents(
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
