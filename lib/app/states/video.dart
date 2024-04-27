import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video.g.dart';

@riverpod
class VideoNotifier extends _$VideoNotifier {
  @override
  BetterPlayerController? build() => null;

  double aspectRatio = 19 / 6;

  void setupController() {
    state = BetterPlayerController(
      BetterPlayerConfiguration(
        autoDispose: false,
        allowedScreenSleep: false,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: false,
          showControlsOnInitialize: false,
        ),
        showPlaceholderUntilPlay: true,
        autoPlay: true,
        aspectRatio: aspectRatio,
      ),
    );
  }

  void init(BuildContext context) {
    aspectRatio = MediaQuery.of(context).size.aspectRatio;
    setupController();
    ref.onDispose(() {
      state?.dispose(forceDispose: true);
      state = null;
    });
  }

  void setDatasource(String url) {
    state?.setupDataSource(
      BetterPlayerDataSource.network(
        url,
      ),
    );
  }

  void preCache(String url) {
    state?.preCache(
      BetterPlayerDataSource.network(
        url,
      ),
    );
  }

  void dispose({bool force = false, bool reinitialize = true}) {
    print('DISPOSING VIDEO STATE');
    state?.dispose(forceDispose: force);
    if (reinitialize) {
      setupController();
    }
  }
}
