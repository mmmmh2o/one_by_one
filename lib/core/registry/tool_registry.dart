import 'package:flutter/material.dart';

import '../../features/base_converter/base_converter_page.dart';
import '../../features/common/tool_shell_page.dart';
import '../../features/coin/coin_page.dart';
import '../../features/date_calculator/date_calculator_page.dart';
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
  ToolEntry(
    id: 'coin',
    name: '抛硬币',
    description: '随机正反面并统计次数',
    icon: Icons.toll,
    category: ToolCategory.other,
    builder: (_) => const CoinPage(),
    isOffline: true,
    sortOrder: 5,
  ),
  ToolEntry(
    id: 'base_converter',
    name: '进制转换',
    description: '2/8/10/16/32/36 进制互转',
    icon: Icons.numbers,
    category: ToolCategory.calculator,
    builder: (_) => const BaseConverterPage(),
    isOffline: true,
    sortOrder: 6,
  ),
  ToolEntry(
    id: 'date_calculator',
    name: '日期计算',
    description: '计算两个日期之间的天数与周数',
    icon: Icons.date_range,
    category: ToolCategory.daily,
    builder: (_) => const DateCalculatorPage(),
    isOffline: true,
    sortOrder: 7,
  ),
];

final Map<String, ToolEntry> toolIndex = {
  for (final tool in allTools) tool.id: tool,
};

ToolEntry? getToolById(String id) => toolIndex[id];
