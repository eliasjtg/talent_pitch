import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/talent.dart';

class HighlightedImageTalents extends StatelessWidget {
  /// [loading]
  final bool loading;

  /// Parent [category]
  final Category category;

  /// List of [talents]
  final List<Talent>? talents;

  const HighlightedImageTalents(
      {super.key, required this.loading, this.talents, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: !loading && (talents?.isEmpty ?? true) ? const Center(
        child: Text('Sin resultados'),
      ) : ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                imageUrl: category.image!,
                placeholder: (BuildContext context, String url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (BuildContext context, String url, Object? error) =>
                        const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          if (loading && talents == null)
            Skeletonizer(
                child: Row(
              children: List.generate(
                  3,
                  (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: HighlightedLoadingTalent(),
                      )),
            )),
          if (talents != null)
            Row(
              children: talents!
                  .map((Talent talent) => HighlightedTalent(
                        talent: talent,
                      ))
                  .toList(),
            )
        ],
      ),
    );
  }
}

class HighlightedTalent extends StatelessWidget {
  /// [talent]
  final Talent talent;

  const HighlightedTalent({super.key, required this.talent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: talent.avatar != null
                ? Image.network(talent.avatar!).image
                : null,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(talent.name, overflow: TextOverflow.clip,),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          OutlinedButton(onPressed: () {}, child: const Text('Follow')),
        ],
      ),
    );
  }
}

class HighlightedLoadingTalent extends StatelessWidget {
  const HighlightedLoadingTalent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 25,
        ),
        const Text('Talent name'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        OutlinedButton(onPressed: () {}, child: const Text('Follow')),
      ],
    );
  }
}
