import 'package:flutter/material.dart';

import '../../features/common/tool_shell_page.dart';
import '../../features/dice/dice_page.dart';
import '../../features/random/random_page.dart';
import '../../features/ruler/ruler_page.dart';
import '../../features/unit_converter/unit_converter_page.dart';
import '../../models/tool_entry.dart';

final List<ToolEntry> allTools = [
  ToolEntry(
    id: 'ruler',
    name: '尺子',
    description: '屏幕尺子，厘米/英寸实时显示',
    icon: Icons.straighten,
    category: ToolCategory.daily,
    builder: (_) => const RulerPage(),
    isOffline: true,
    sortOrder: 1,
  ),
  ToolEntry(
    id: 'random_number',
    name: '随机数',
    description: '生成任意范围的随机数',
    icon: Icons.shuffle,
    category: ToolCategory.other,
    builder: (_) => const RandomPage(),
    isOffline: true,
    sortOrder: 2,
  ),
  ToolEntry(
    id: 'dice',
    name: '掷骰子',
    description: '支持多颗骰子与动画',
    icon: Icons.casino,
    category: ToolCategory.other,
    builder: (_) => const DicePage(),
    isOffline: true,
    sortOrder: 3,
  ),
  ToolEntry(
    id: 'unit_converter',
    name: '单位换算',
    description: '长度/重量/温度等单位互转',
    icon: Icons.swap_horiz,
    category: ToolCategory.calculator,
    builder: (_) => const UnitConverterPage(),
    isOffline: true,
    sortOrder: 4,
  ),
];

final Map<String, ToolEntry> toolIndex = {
  for (final tool in allTools) tool.id: tool,
};

ToolEntry? getToolById(String id) => toolIndex[id];
