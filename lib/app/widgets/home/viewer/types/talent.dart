import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:readmore/readmore.dart';
import 'package:talent_pitch/app/models/talent.dart';

class TalentViewerWidget extends StatelessWidget {
  /// [talent]
  final Talent talent;

  /// Video [controller]
  final BetterPlayerController? controller;

  const TalentViewerWidget(
      {super.key, required this.talent, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: const SizedBox.expand(),
        ),
        if (controller != null && talent.video != null)
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: BetterPlayer(
              controller: controller!,
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 65),
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
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Expanded(
                        child: Text(
                      talent.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ],
                ),
                if (talent.about != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ReadMoreText(
                      talent.about!,
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: Colors.pink,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}