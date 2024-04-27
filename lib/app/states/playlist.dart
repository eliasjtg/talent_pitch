import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/category.dart';
import 'package:talent_pitch/app/states/playlist_category.dart';
import 'package:talent_pitch/app/states/video.dart';

part 'playlist.g.dart';

@Riverpod(keepAlive: true)
class PlaylistNotifier extends _$PlaylistNotifier {
  @override
  BaseModel? build() => null;

  void setCategory(Category category, int indexModel) {
    state = category.models[indexModel];
    ref.read(playlistCategoryNotifierProvider.notifier).setCategory(category);
  }

  void previous() {
    final model = ref.read(playlistCategoryNotifierProvider.notifier).previous(state!);
    if(model != null) {
      state = model;
    }
  }

  void next() {
    final model = ref.read(playlistCategoryNotifierProvider.notifier).next(state!);
    if(model != null) {
      state = model;
    }
  }

  void onClose() {
    state = null;
    ref.read(playlistCategoryNotifierProvider.notifier).onClose();
    ref.read(videoNotifierProvider.notifier).dispose(force: true);
  }

  @override
  bool updateShouldNotify(BaseModel? previous, BaseModel? next) {
    if(next != null && next.video != null) {
      ref.read(videoNotifierProvider.notifier).setDatasource(next.video!);
    } else {
      try {
        ref.read(videoNotifierProvider)?.pause();
      } catch(_){}
    }
    return super.updateShouldNotify(previous, next);
  }
}
