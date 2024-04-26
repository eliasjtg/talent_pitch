import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/talent.dart';

class TopListTalents extends StatelessWidget {
  /// [loading]
  final bool loading;

  /// Parent [category]
  final Category category;

  /// List of [talents]
  final List<Talent>? talents;

  const TopListTalents(
      {super.key, required this.loading, this.talents, required this.category});

  @override
  Widget build(BuildContext context) {
    return talents != null
        ? Column(
            children: talents!
                .mapIndexed((int index, Talent talent) => TopListTalent(
                      index: index + 1,
                      talent: talent,
                    ))
                .toList(),
          )
        : Skeletonizer(
            child: Column(
            children: List.generate(4, (index) => const TopListLoadingTalent()),
          ));
  }
}

class TopListTalent extends StatelessWidget {
  /// List [index]
  final int index;

  /// [talent]
  final Talent talent;

  const TopListTalent({super.key, required this.talent, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        index.toString(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: talent.avatar != null
                ? Image.network(talent.avatar!).image
                : null,
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Flexible(
              child: Text(
            talent.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }
}

class TopListLoadingTalent extends StatelessWidget {
  const TopListLoadingTalent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Text('1'),
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 25,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Text('Talent name'),
        ],
      ),
    );
  }
}
