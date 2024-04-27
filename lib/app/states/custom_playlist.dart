import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
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
    await repository.removeModel(model);
    state = List<BaseModel>.from(state)..remove(model);
  }
}
