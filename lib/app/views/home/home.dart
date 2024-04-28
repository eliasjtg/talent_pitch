import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/current_nav_index.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/widgets/home/body.dart';
import 'package:talent_pitch/app/widgets/home/nav_bar.dart';

/// Home view
class HomeView extends ConsumerStatefulWidget {
  /// Home view constructor
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeViewState();
}

/// Home view state
class HomeViewState extends ConsumerState<HomeView> {
  /// Nav listener
  late final ProviderSubscription<int> navListen;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// Init custom playlist initializer
      ref.read(customPlaylistNotifierProvider.notifier).init();
    });

    /// Init listener
    /// Temporal listener to dispose state
    navListen = ref.listenManual(currentNavIndexProvider, (previous, next) {
      /// If changing from custom playlist to home
      if (previous == 1 && next == 0) {
        /// Close
        ref.read(currentCustomNotifierProvider.notifier).onClose();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Keep alive custom playlist at home Scaffold
    ref.watch(customPlaylistNotifierProvider);
    return const Scaffold(
      body: HomeBody(),
      bottomNavigationBar: HomeNavigationBar(),
    );
  }

  @override
  void dispose() {
    /// Dispose listener
    navListen.close();
    super.dispose();
  }
}
