import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/states/playlist.dart';
import 'package:talent_pitch/app/states/video.dart';
import 'package:talent_pitch/app/widgets/home/viewer/viewer.dart';

/// Pitch viewer
class PlaylistViewer extends ConsumerWidget {
  /// PlaylistViewer constructor
  const PlaylistViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(playlistNotifierProvider);
    final controller = ref.watch(videoNotifierProvider);

    /// [Know issue don't invoke pop with go router](https://github.com/flutter/flutter/issues/138737)
    return PopScope(
      child: ViewerView(
        model: current,
        controller: controller,
        onSwipeLeft: ref.read(playlistNotifierProvider.notifier).previous,
        onSwipeRight: ref.read(playlistNotifierProvider.notifier).next,
      ),
      onPopInvoked: (popped) {
        ref.read(playlistNotifierProvider.notifier).onClose();
      },
    );
  }
}
