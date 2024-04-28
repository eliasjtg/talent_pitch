import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/states/video.dart';
import 'package:talent_pitch/app/widgets/home/viewer/viewer.dart';

class CustomPlaylistSection extends ConsumerWidget {
  const CustomPlaylistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(customPlaylistNotifierProvider);
    return models.isEmpty
        ? const Center(
            child: Text('No hay pitch\'s en la playlist'),
          )
        : CustomPlaylistPlayer(models: models);
  }
}

class CustomPlaylistPlayer extends ConsumerStatefulWidget {
  final List<BaseModel> models;

  const CustomPlaylistPlayer({super.key, required this.models});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CustomPlaylistPlayerState();
}

class CustomPlaylistPlayerState extends ConsumerState<CustomPlaylistPlayer> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(currentCustomNotifierProvider.notifier).init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(currentCustomNotifierProvider);
    final controller = ref.watch(videoNotifierProvider);

    /// [Know issue don't invoke pop with go router](https://github.com/flutter/flutter/issues/138737)
    return ViewerView(
      model: current,
      controller: controller,
      onSwipeLeft: ref.read(currentCustomNotifierProvider.notifier).previous,
      onSwipeRight: ref.read(currentCustomNotifierProvider.notifier).next,
    );
  }
}
