import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video.g.dart';

/// Video controller state
@riverpod
class VideoNotifier extends _$VideoNotifier {
  /// Player controller
  @override
  BetterPlayerController? build() => null;

  /// Default aspect ratio
  double aspectRatio = 19 / 6;

  /// Setup player controller
  void setupController() {
    /// Set state
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

  /// Init state
  void init(BuildContext context) {
    /// Setup aspect ratio from context
    aspectRatio = MediaQuery.of(context).size.aspectRatio;

    /// Setup player controller
    setupController();

    /// On dispose callback
    ref.onDispose(() {
      /// Dispose controller
      state?.dispose(forceDispose: true);

      /// Set controller to null
      state = null;
    });
  }

  /// Set data source from url
  void setDatasource(String url) {
    state?.setupDataSource(
      BetterPlayerDataSource.network(
        url,
      ),
    );
  }

  /// Pre cache video from url
  void preCache(String url) {
    state?.preCache(
      BetterPlayerDataSource.network(
        url,
      ),
    );
  }

  /// Dispose controller
  void dispose({bool force = false, bool reinitialize = true}) {
    /// Dispose controller
    state?.dispose(forceDispose: force);

    /// If reinitialize
    if (reinitialize) {
      /// Setup new controller
      setupController();
    } else {
      /// Set state to null
      state = null;
    }
  }
}
