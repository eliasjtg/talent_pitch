import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/states/video.dart';
import 'package:talent_pitch/app/widgets/home/viewer/viewer.dart';

/// Custom playlist section
class CustomPlaylistSection extends ConsumerWidget {
  /// CustomPlaylistSection constructor
  const CustomPlaylistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(customPlaylistNotifierProvider);
    return models.isEmpty
        ? Center(
            child: Text(
              AppLocalizations.of(context)!.no_pitch_available,
            ),
          )
        : CustomPlaylistPlayer(models: models);
  }
}

/// Custom playlist player
class CustomPlaylistPlayer extends ConsumerStatefulWidget {
  /// Pitch [models]
  final List<BaseModel> models;

  /// CustomPlaylistPlayer constructor
  const CustomPlaylistPlayer({super.key, required this.models});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CustomPlaylistPlayerState();
}

/// Custom playlist player state
class CustomPlaylistPlayerState extends ConsumerState<CustomPlaylistPlayer> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// Init current custom
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
