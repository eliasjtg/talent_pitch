import 'package:flutter/material.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/talent.dart';
import 'package:talent_pitch/app/states/repositories/talent.dart';
import 'package:talent_pitch/app/widgets/home/categories/talents/highlighted_image.dart';
import 'package:talent_pitch/app/widgets/home/categories/talents/top_list.dart';

class TalentsItem extends StatefulWidget {
  /// Item [category]
  final Category category;

  /// [talentRepository]
  final TalentRepository talentRepository = TalentRepository();

  TalentsItem({super.key, required this.category});

  @override
  State<StatefulWidget> createState() => TalentsItemState();
}

class TalentsItemState extends State<TalentsItem> with AutomaticKeepAliveClientMixin {

  late final Future<List<Talent>> futureTalents;

  @override
  void initState() {
    futureTalents = widget.talentRepository.categoryUrlTalents(widget.category.url);
    super.initState();
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
        )
            : TopListTalents(
          loading: snapshot.connectionState == ConnectionState.waiting,
          category: widget.category,
          talents: snapshot.data,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
