import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_nav_index.g.dart';

/// Nav current index state
@riverpod
class CurrentNavIndex extends _$CurrentNavIndex {
  @override
  int build() => 0;

  /// Change index
  set currentIndex(int index) => state = index;
}
