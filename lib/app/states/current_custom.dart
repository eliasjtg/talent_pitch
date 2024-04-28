import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/states/video.dart';

part 'current_custom.g.dart';

/// Custom playlist current pitch state
@riverpod
class CurrentCustomNotifier extends _$CurrentCustomNotifier {
  @override
  BaseModel? build() => null;

  /// Set current model
  set current(BaseModel? model) => state = model;

  /// Set first custom playlist item to current
  void init() {
    final model = ref.read(customPlaylistNotifierProvider).firstOrNull;
    if (model != null) {
      state = model;
    }
  }

  /// Set current from previous list item
  void previous() {
    final models = ref.read(customPlaylistNotifierProvider);
    final index = models.indexOf(state!);
    if (index > 0) {
      state = models[index - 1];
    }
  }

  /// Set current from next list item
  void next() {
    final models = ref.read(customPlaylistNotifierProvider);
    final index = models.indexOf(state!);
    if (index < models.length - 1) {
      state = models[index + 1];
    }
  }

  /// On close viewer callback
  void onClose() {
    /// Setup current to null
    state = null;

    /// Dispose video state
    ref.read(videoNotifierProvider.notifier).dispose(force: true);
  }

  /// Change video state on change current
  @override
  bool updateShouldNotify(BaseModel? previous, BaseModel? next) {
    final videoController = ref.read(videoNotifierProvider);

    /// If changed state has video url
    if (next != null && next.video != null) {
      /// Set video state data source
      ref.read(videoNotifierProvider.notifier).setDatasource(next.video!);
    }

    /// If video state is initialized
    else if (videoController?.videoPlayerController != null) {
      try {
        videoController?.pause();
      } catch (_) {}
    }

    /// Return parent value
    return super.updateShouldNotify(previous, next);
  }
}
