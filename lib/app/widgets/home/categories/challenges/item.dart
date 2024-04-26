import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/states/repositories/challenge.dart';

class ChallengesItem extends StatefulWidget {
  /// Item [category]
  final Category category;

  /// [challengeRepository]
  final ChallengeRepository challengeRepository = ChallengeRepository();

  ChallengesItem({super.key, required this.category});

  @override
  State<StatefulWidget> createState() => TalentsItemState();
}

class TalentsItemState extends State<ChallengesItem>
    with AutomaticKeepAliveClientMixin {
  late final Future<List<Challenge>> futureChallenges;

  @override
  void initState() {
    futureChallenges =
        widget.challengeRepository.categoryUrlChallenges(widget.category.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Challenge>>(
      future: futureChallenges,
      builder: (BuildContext context, AsyncSnapshot<List<Challenge>> snapshot) {
        return ChallengeItem(
          loading: snapshot.connectionState == ConnectionState.waiting,
          category: widget.category,
          challenges: snapshot.data,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ChallengeItem extends StatelessWidget {
  /// [loading]
  final bool loading;

  /// Parent [category]
  final Category category;

  /// List of [challenges]
  final List<Challenge>? challenges;

  const ChallengeItem(
      {super.key,
      required this.loading,
      this.challenges,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (category.image != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 130,
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
          if (loading && challenges == null)
            Skeletonizer(
                child: Row(
              children: List.generate(
                  3,
                  (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: LoadingChallenge(),
                      )),
            )),
          if (challenges != null)
            Row(
              children: challenges!
                  .map((Challenge challenge) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChallengeContent(
                  challenge: challenge,
                ),
              ))
                  .toList(),
            )
        ],
      ),
    );
  }
}

class ChallengeContent extends StatelessWidget {
  /// [talent]
  final Challenge challenge;

  const ChallengeContent({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          challenge.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                    imageUrl: challenge.image!,
                    placeholder: (BuildContext context, String url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (BuildContext context, String url, Object? error) =>
                            const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 100,
                  color: Colors.white,
                ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                challenge.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                challenge.companyName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          OutlinedButton(onPressed: () {}, child: const Text('Send pitch')),
        ],
      ),
    );
  }
}

class LoadingChallenge extends StatelessWidget {
  const LoadingChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Skeleton.replace(
          width: 60,
          height: 60,
          child: Icon(Icons.abc),
        ),
        const Text('Name'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        const Text('Company'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        OutlinedButton(onPressed: () {}, child: const Text('Send')),
      ],
    );
  }
}
