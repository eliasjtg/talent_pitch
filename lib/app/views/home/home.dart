import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/states/current_custom.dart';
import 'package:talent_pitch/app/states/current_nav_index.dart';
import 'package:talent_pitch/app/states/custom_playlist.dart';
import 'package:talent_pitch/app/views/home/navs/categories.dart';
import 'package:talent_pitch/app/views/home/navs/custom_playlist.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  late final ProviderSubscription<int> navListen;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(customPlaylistNotifierProvider.notifier).init();
    });
    navListen = ref.listenManual(currentNavIndexProvider, (previous, next) {
      if(previous == 1 && next == 0) {
        /// Close
        ref.read(currentCustomNotifierProvider.notifier).onClose();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(customPlaylistNotifierProvider);
    return const Scaffold(
      body: HomeBody(),
      bottomNavigationBar: HomeNavigationBar(),
    );
  }

  @override
  void dispose() {
    navListen.close();
    super.dispose();
  }
}

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentNavIndexProvider);
    return SafeArea(
      child: currentIndex == 1
          ? const CustomPlaylistSection()
          : const CategoriesSection(),
    );
  }
}

class HomeNavigationBar extends ConsumerWidget {
  const HomeNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentNavIndexProvider);
    return NavigationBar(
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home_outlined),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.playlist_play),
          icon: Icon(Icons.playlist_play),
          label: 'Playlist',
        ),
      ],
      onDestinationSelected: (int index) {
        ref.read(currentNavIndexProvider.notifier).currentIndex = index;
      },
    );
  }
}
