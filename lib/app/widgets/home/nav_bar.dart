import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talent_pitch/app/states/current_nav_index.dart';

/// Home
class HomeNavigationBar extends ConsumerWidget {
  const HomeNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentNavIndexProvider);
    return NavigationBar(
      selectedIndex: currentIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.home_outlined),
          icon: const Icon(Icons.home_outlined),
          label: AppLocalizations.of(context)!.nav_home,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.playlist_play),
          icon: const Icon(Icons.playlist_play),
          label: AppLocalizations.of(context)!.nav_playlist,
        ),
      ],
      onDestinationSelected: (int index) {
        ref.read(currentNavIndexProvider.notifier).currentIndex = index;
      },
    );
  }
}
