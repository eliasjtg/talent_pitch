import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/states/current_nav_index.dart';
import 'package:talent_pitch/app/views/home/navs/categories.dart';
import 'package:talent_pitch/app/views/home/navs/custom_playlist.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeBody(),
      bottomNavigationBar: HomeNavigationBar(),
    );
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
