import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';

class ChallengeViewerWidget extends ConsumerWidget {
  /// [challenge]
  final Challenge challenge;

  /// Video [controller]
  final BetterPlayerController? controller;

  const ChallengeViewerWidget(
      {super.key, required this.challenge, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(customPlaylistNotifierProvider);
    final inPlaylist =
        ref.watch(customPlaylistNotifierProvider.notifier).contain(challenge);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: const SizedBox.expand(),
        ),
        if (controller != null &&
            challenge.video != null &&
            controller?.videoPlayerController != null)
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: BetterPlayer(
              controller: controller!,
            ),
          ),
        if (challenge.video == null && challenge.image != null)
          Image.network(
            challenge.image!,
            fit: BoxFit.contain,
          ),
        if ((controller == null || challenge.video == null) &&
            challenge.image == null)
          const Center(
            child: Text(
              'Sin pitch',
              style: TextStyle(color: Colors.white),
            ),
          ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            iconSize: 32,
            icon: inPlaylist
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite),
            onPressed: () {
              inPlaylist
                  ? ref
                      .read(customPlaylistNotifierProvider.notifier)
                      .remove(challenge)
                  : ref
                      .read(customPlaylistNotifierProvider.notifier)
                      .store(challenge);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (challenge.description != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: challenge.video != null
                          ? ReadMoreText(
                              challenge.description!,
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(challenge.description!,
                              style: const TextStyle(color: Colors.white)),
                    ),
                  if (challenge.companyName != null &&
                      challenge.companyLogo != null)
                    Row(
                      children: [
                        if (challenge.companyLogo != null)
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: challenge.companyLogo != null
                                ? Image.network(challenge.companyLogo!).image
                                : null,
                          ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5)),
                        if (challenge.companyName != null)
                          Expanded(
                              child: Text(
                            challenge.companyName!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          )),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
