import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/states/categories.dart';
import 'package:talent_pitch/app/states/playlist.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talent_pitch/app/states/repositories/challenge.dart';

/// Challenges item
class ChallengesItem extends ConsumerStatefulWidget {
  /// Item [category]
  final Category category;

  /// [challengeRepository] instance
  final ChallengeRepository challengeRepository = ChallengeRepository();

  /// ChallengesItem instance
  ChallengesItem({super.key, required this.category});

  @override
  TalentsItemState createState() => TalentsItemState();
}

/// Challenges item state
class TalentsItemState extends ConsumerState<ChallengesItem>
    with AutomaticKeepAliveClientMixin {
  /// [futureChallenges]
  late final Future<List<Challenge>> futureChallenges;

  @override
  void initState() {
    /// Fetch challenges from principal category
    futureChallenges =
        widget.challengeRepository.categoryUrlChallenges(widget.category.url);
    futureChallenges.then(
      (List<Challenge> challenges) => ref
          .read(asyncCategoriesProvider.notifier)

          /// Load models to category
          .setCategoryModels(widget.category, challenges),
    );
    super.initState();
  }

  /// On tap challenge
  void onTapChallenge(int index, Challenge challenge) {
    ref
        .read(playlistNotifierProvider.notifier)

        /// Set category and current challenge
        .setCategory(widget.category, index);
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
    return FutureBuilder<List<Challenge>>(
      future: futureChallenges,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Challenge>> snapshot,
      ) =>
          ChallengeItem(
        loading: snapshot.connectionState == ConnectionState.waiting,
        category: widget.category,
        challenges: snapshot.data,
        onTap: onTapChallenge,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Challenge item
class ChallengeItem extends StatelessWidget {
  /// [loading]
  final bool loading;

  /// Parent [category]
  final Category category;

  /// List of [challenges]
  final List<Challenge>? challenges;

  /// [onTap] on talent
  final void Function(int index, Challenge challenge) onTap;

  /// ChallengeItem constructor
  const ChallengeItem({
    super.key,
    required this.loading,
    this.challenges,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: !loading && (challenges?.isEmpty ?? true)
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.without_results,
              ),
            )
          : ListView(
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
                        placeholder: (
                          BuildContext context,
                          String url,
                        ) =>
                            const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (
                          BuildContext context,
                          String url,
                          Object? error,
                        ) =>
                            const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                ),
                if (loading && challenges == null)
                  Skeletonizer(
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: LoadingChallenge(),
                        ),
                      ),
                    ),
                  ),
                if (challenges != null)
                  Row(
                    children: challenges!
                        .mapIndexed(
                          (int index, Challenge challenge) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            child: ChallengeContent(
                              challenge: challenge,
                              onTap: () => onTap(index, challenge),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
    );
  }
}

/// Challenge content
class ChallengeContent extends StatelessWidget {
  /// [talent]
  final Challenge challenge;

  /// [onTap] callback
  final VoidCallback onTap;

  /// ChallengeContent constructor
  const ChallengeContent({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: challenge.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                      imageUrl: challenge.image!,
                      placeholder: (
                        BuildContext context,
                        String url,
                      ) =>
                          const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (
                        BuildContext context,
                        String url,
                        Object? error,
                      ) =>
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
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 1),
          ),
          Flexible(
            child: GestureDetector(
              onTap: onTap,
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
          ),
          if (challenge.companyName != null)
            Flexible(
              child: GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    challenge.companyName!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          OutlinedButton(
            onPressed: () {},
            child: Text(
              AppLocalizations.of(context)!.send_pitch,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading challenge
class LoadingChallenge extends StatelessWidget {
  /// LoadingChallenge constructor
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
        OutlinedButton(
          onPressed: () {},
          child: Text(
            AppLocalizations.of(context)!.send_pitch,
          ),
        ),
      ],
    );
  }
}
