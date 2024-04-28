import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/playlist_category.dart';
import 'package:talent_pitch/app/states/video.dart';

part 'playlist.g.dart';

/// Viewer current pitch
@Riverpod(keepAlive: true)
class PlaylistNotifier extends _$PlaylistNotifier {
  /// Current pitch
  @override
  BaseModel? build() => null;

  /// Set current with category index
  void setCategory(Category category, int indexModel) {
    /// Set current pitch
    state = category.models[indexModel];

    /// Set current category
    ref.read(playlistCategoryNotifierProvider.notifier).setCategory(category);
  }

  /// Change to previous pitch
  void previous() {
    /// Get category previous pitch
    final model =
        ref.read(playlistCategoryNotifierProvider.notifier).previous(state!);

    /// If has previous
    if (model != null) {
      /// Set current
      state = model;
    }
  }

  /// Change to next pitch
  void next() {
    /// Get category next pitch
    final model =
        ref.read(playlistCategoryNotifierProvider.notifier).next(state!);

    /// If has next
    if (model != null) {
      /// Set current
      state = model;
    }
  }

  /// On close viewer callback
  void onClose() {
    /// Set current to null
    state = null;

    /// Close playlist category
    ref.read(playlistCategoryNotifierProvider.notifier).onClose();

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
