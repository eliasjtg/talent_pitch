import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/models/company.dart';
import 'package:talent_pitch/app/models/talent.dart';
import 'package:talent_pitch/app/widgets/home/viewer/types/challenge.dart';
import 'package:talent_pitch/app/widgets/home/viewer/types/company.dart';
import 'package:talent_pitch/app/widgets/home/viewer/types/talent.dart';

class ViewerView extends ConsumerWidget {
  /// View [model]
  final BaseModel? model;

  /// Video [controller]
  final BetterPlayerController? controller;

  final VoidCallback? onSwipeLeft;

  final VoidCallback? onSwipeRight;

  const ViewerView({
    super.key,
    this.model,
    this.controller,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if ((details.primaryVelocity ?? 0) >= 500) {
              print('SWIPE LEFT');
              onSwipeLeft?.call();
            }
            if ((details.primaryVelocity ?? 0) <= 500) {
              print('SWIPE RIGHT');
              onSwipeRight?.call();
            }
          },
          onTap: () {
            if (controller?.isVideoInitialized() == true) {
              controller!.isPlaying() == true
                  ? controller!.pause()
                  : controller!.play();
            }
          },
          child: Center(
            child: getType(),
          ),
        ),
      ),
    );
  }

  Widget getType() {
    if (model is Talent) {
      return TalentViewerWidget(
          talent: model as Talent, controller: controller);
    }
    if (model is Challenge) {
      return ChallengeViewerWidget(
          challenge: model as Challenge, controller: controller);
    }
    if (model is Company) {
      return CompanyViewerWidget(
          company: model as Company, controller: controller);
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
