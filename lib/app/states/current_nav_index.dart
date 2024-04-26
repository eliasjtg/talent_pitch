import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_nav_index.g.dart';

@riverpod
class CurrentNavIndex extends _$CurrentNavIndex {
  @override
  int build() => 0;

  set currentIndex(int index) => state = index;
}
