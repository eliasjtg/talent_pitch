import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/states/video.dart';

part 'current_custom.g.dart';

@riverpod
class CurrentCustomNotifier extends _$CurrentCustomNotifier {
  @override
  BaseModel? build() => null;

  set current(BaseModel? model) => state = model;

  void init() {
    final model = ref.read(customPlaylistNotifierProvider).firstOrNull;
    if (model != null) {
      state = model;
    }
  }

  void previous() {
    final models = ref.read(customPlaylistNotifierProvider);
    final index = models.indexOf(state!);
    if (index > 0) {
      state = models[index - 1];
    }
  }

  void next() {
    final models = ref.read(customPlaylistNotifierProvider);
    final index = models.indexOf(state!);
    if (index < models.length - 1) {
      state = models[index + 1];
    }
  }

  void onClose() {
    state = null;
    ref.read(videoNotifierProvider.notifier).dispose(force: true);
  }

  @override
  bool updateShouldNotify(BaseModel? previous, BaseModel? next) {
    if (next != null && next.video != null) {
      ref.read(videoNotifierProvider.notifier).setDatasource(next.video!);
    } else {
      try {
        ref.read(videoNotifierProvider)?.pause();
      } catch (_) {}
    }
    return super.updateShouldNotify(previous, next);
  }
}
