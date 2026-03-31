import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 最近使用的工具 ID 列表（按使用时间倒序，最新在前）。
class RecentToolsNotifier extends StateNotifier<List<String>> {
  static const _key = 'recents.tool_ids';
  static const _max = 8;

  RecentToolsNotifier() : super(const []) {
    unawaited(_load());
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_key) ?? [];
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state);
  }

  /// 记录一次工具使用（去重 + 置顶）。
  void recordUse(String toolId) {
    final list = [toolId, ...state.where((id) => id != toolId)];
    if (list.length > _max) list.removeRange(_max, list.length);
    state = list;
    unawaited(_save());
  }

  void clear() {
    state = [];
    unawaited(_save());
  }
}

final recentToolsProvider =
    StateNotifierProvider<RecentToolsNotifier, List<String>>(
  (ref) => RecentToolsNotifier(),
);
