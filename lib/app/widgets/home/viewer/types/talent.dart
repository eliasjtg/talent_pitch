import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:talent_pitch/app/models/talent.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/widgets/show_more.dart';

/// Pitch talent viewer
class TalentViewerWidget extends ConsumerWidget {
  /// [talent]
  final Talent talent;

  /// Video [controller]
  final BetterPlayerController? controller;

  /// TalentViewerWidget constructor
  const TalentViewerWidget({
    super.key,
    required this.talent,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(customPlaylistNotifierProvider);
    final inPlaylist =
        ref.watch(customPlaylistNotifierProvider.notifier).contain(talent);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: const SizedBox.expand(),
        ),
        if (controller != null &&
            talent.video != null &&
            controller?.videoPlayerController != null)
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: BetterPlayer(
              controller: controller!,
            ),
          ),
        if (controller == null || talent.video == null)
          Center(
            child: Text(
              AppLocalizations.of(context)!.without_pitch,
              style: const TextStyle(color: Colors.white),
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
                      .remove(talent)
                  : ref
                      .read(customPlaylistNotifierProvider.notifier)
                      .store(talent);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 10,
              right: 65,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: talent.avatar != null
                          ? Image.network(talent.avatar!).image
                          : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    Expanded(
                      child: Text(
                        talent.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (talent.about != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: ShowMoreWidget(
                      talent.about!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
