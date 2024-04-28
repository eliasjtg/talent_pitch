import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/repositories/custom_playlist.dart';

part 'custom_playlist.g.dart';

/// Custom playlist pitch's
@Riverpod(keepAlive: true)
class CustomPlaylistNotifier extends _$CustomPlaylistNotifier {
  /// Pitch's list
  @override
  List<BaseModel> build() => [];

  /// Repository instance
  final CustomPlaylistRepository repository = CustomPlaylistRepository();

  /// Init state retrieving from permanent storage
  Future<void> init() async {
    state = await repository.getModels();
  }

  /// Pitch's list contain item
  bool contain(BaseModel model) {
    return state.contains(model);
  }

  /// Store into pitch's list
  Future<void> store(BaseModel model) async {
    await repository.storeModel(model);
    state = List<BaseModel>.from(state)..add(model);
  }

  /// Remove from pitch's list
  Future<void> remove(BaseModel model) async {
    final next = nextModel(model);
    await repository.removeModel(model);
    state = List<BaseModel>.from(state)..remove(model);
    ref.read(currentCustomNotifierProvider.notifier).current = next;
  }

  /// Calculate next item
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
