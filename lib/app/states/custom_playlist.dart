import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/repositories/custom_playlist.dart';

part 'custom_playlist.g.dart';

@Riverpod(keepAlive: true)
class CustomPlaylistNotifier extends _$CustomPlaylistNotifier {
  @override
  List<BaseModel> build() => [];

  final CustomPlaylistRepository repository = CustomPlaylistRepository();

  Future<void> init() async {
    state = await repository.getModels();
  }

  bool contain(BaseModel model) {
    return state.contains(model);
  }

  Future<void> store(BaseModel model) async {
    await repository.storeModel(model);
    state = List<BaseModel>.from(state)..add(model);
  }

  Future<void> remove(BaseModel model) async {
    final next = nextModel(model);
    await repository.removeModel(model);
    state = List<BaseModel>.from(state)..remove(model);
    ref.read(currentCustomNotifierProvider.notifier).current = next;
  }

  BaseModel? nextModel(BaseModel model) {
    if (state.length == 1) {
      return null;
    }

    final index = state.indexOf(model);

    if (index != -1) {
      if (index < state.length - 1) {
        return state[index + 1];
      }
      if (index > 0) {
        return state[index - 1];
      }
    }

    return null;
  }
}
