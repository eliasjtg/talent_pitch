import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/states/current_nav_index.dart';
import 'package:talent_pitch/app/views/home/navs/categories.dart';
import 'package:talent_pitch/app/views/home/navs/custom_playlist.dart';

/// Home body
class HomeBody extends ConsumerWidget {
  /// Home body constructor
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Current navigator index
    final int currentIndex = ref.watch(currentNavIndexProvider);
    return SafeArea(
      child: currentIndex == 1
          ? const CustomPlaylistSection()
          : const CategoriesSection(),
    );
  }
}
