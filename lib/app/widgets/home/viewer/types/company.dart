import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:talent_pitch/app/models/company.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';

class CompanyViewerWidget extends ConsumerWidget {
  /// [company]
  final Company company;

  /// Video [controller]
  final BetterPlayerController? controller;

  const CompanyViewerWidget(
      {super.key, required this.company, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(customPlaylistNotifierProvider);
    final inPlaylist =
        ref.watch(customPlaylistNotifierProvider.notifier).contain(company);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: const SizedBox.expand(),
        ),
        if (controller != null &&
            company.video != null &&
            controller?.videoPlayerController != null)
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: BetterPlayer(
              controller: controller!,
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
                      .remove(company)
                  : ref
                      .read(customPlaylistNotifierProvider.notifier)
                      .store(company);
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
                  if (company.description != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: company.video != null
                          ? ReadMoreText(
                              company.description!,
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(company.description!,
                              style: const TextStyle(color: Colors.white)),
                    ),
                  Row(
                    children: [
                      if (company.logo != null)
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: company.logo != null
                              ? Image.network(company.logo!).image
                              : null,
                        ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(
                          child: Text(
                        company.name,
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
