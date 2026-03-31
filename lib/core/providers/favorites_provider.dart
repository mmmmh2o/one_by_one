import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 收藏的工具 ID 集合。
class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const _key = 'favorites.tool_ids';

  FavoritesNotifier() : super(const {}) {
    unawaited(_load());
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getStringList(_key) ?? {}).toSet();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.toList());
  }

  bool isFavorite(String toolId) => state.contains(toolId);

  void toggle(String toolId) {
    if (state.contains(toolId)) {
      state = {...state}..remove(toolId);
    } else {
      state = {...state, toolId};
    }
    unawaited(_save());
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);
