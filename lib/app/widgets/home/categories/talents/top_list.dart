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

  /// [onTap] on talent
  final void Function(int index, Talent talent) onTap;

  const TopListTalents(
      {super.key,
      required this.loading,
      this.talents,
      required this.category,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return loading
        ? Skeletonizer(
            child: Column(
            children: List.generate(4, (index) => const TopListLoadingTalent()),
          ))
        : (talents?.isEmpty ?? true)
            ? const Center(
                child: Text('Sin resultados'),
              )
            : Column(
                children: talents!
                    .mapIndexed((int index, Talent talent) => TopListTalent(
                          index: index + 1,
                          talent: talent,
                          onTap: () {
                            onTap(index, talent);
                          },
                        ))
                    .toList(),
              );
  }
}

class TopListTalent extends StatelessWidget {
  /// List [index]
  final int index;

  /// [talent]
  final Talent talent;

  /// [onTap] callback
  final VoidCallback onTap;

  const TopListTalent(
      {super.key,
      required this.talent,
      required this.index,
      required this.onTap});

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
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: talent.avatar != null
                        ? Image.network(talent.avatar!).image
                        : null,
                  ),
                  if (talent.video != null)
                    Positioned(
                        bottom: -5,
                        right: -35,
                        child: RawMaterialButton(
                          onPressed: onTap,
                          elevation: 2.0,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          fillColor: const Color(0xFFF5F6F9),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        )),
                ],
              ),
            ),
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
