import 'package:flutter/material.dart';

import '../../features/base64_codec/base64_codec_page.dart';
import '../../features/base_converter/base_converter_page.dart';
import '../../features/bmi/bmi_page.dart';
import '../../features/calculator/calculator_page.dart';
import '../../features/coin/coin_page.dart';
import '../../features/date_calculator/date_calculator_page.dart';
import '../../features/decision_maker/decision_page.dart';
import '../../features/dice/dice_page.dart';
import '../../features/eat_what/eat_what_page.dart';
import '../../features/fullscreen_clock/fullscreen_clock_page.dart';
import '../../features/json_formatter/json_formatter_page.dart';
import '../../features/morse/morse_page.dart';
import '../../features/random/random_page.dart';
import '../../features/random_string/random_string_page.dart';
import '../../features/rmb_uppercase/rmb_uppercase_page.dart';
import '../../features/ruler/ruler_page.dart';
import '../../features/text_compare/text_compare_page.dart';
import '../../features/text_dedup_sort/text_dedup_sort_page.dart';
import '../../features/text_stats/text_stats_page.dart';
import '../../features/unicode_codec/unicode_codec_page.dart';
import '../../features/unit_converter/unit_converter_page.dart';
import '../../features/url_codec/url_codec_page.dart';
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
    id: 'calculator',
    name: '计算器',
    description: '基础四则运算，支持小数',
    icon: Icons.calculate,
    category: ToolCategory.calculator,
    builder: (_) => const CalculatorPage(),
    isOffline: true,
    sortOrder: 5,
  ),
  ToolEntry(
    id: 'coin',
    name: '抛硬币',
    description: '随机正反面并统计次数',
    icon: Icons.toll,
    category: ToolCategory.other,
    builder: (_) => const CoinPage(),
    isOffline: true,
    sortOrder: 6,
  ),
  ToolEntry(
    id: 'base_converter',
    name: '进制转换',
    description: '2/8/10/16/32/36 进制互转',
    icon: Icons.numbers,
    category: ToolCategory.calculator,
    builder: (_) => const BaseConverterPage(),
    isOffline: true,
    sortOrder: 7,
  ),
  ToolEntry(
    id: 'date_calculator',
    name: '日期计算',
    description: '计算两个日期之间的天数与周数',
    icon: Icons.date_range,
    category: ToolCategory.daily,
    builder: (_) => const DateCalculatorPage(),
    isOffline: true,
    sortOrder: 8,
  ),
  ToolEntry(
    id: 'bmi',
    name: 'BMI 计算',
    description: '根据身高体重计算 BMI 与分级',
    icon: Icons.monitor_weight,
    category: ToolCategory.calculator,
    builder: (_) => const BmiPage(),
    isOffline: true,
    sortOrder: 9,
  ),
  ToolEntry(
    id: 'json_formatter',
    name: 'JSON 格式化',
    description: 'JSON 文本格式化与压缩',
    icon: Icons.data_object,
    category: ToolCategory.text,
    builder: (_) => const JsonFormatterPage(),
    isOffline: true,
    sortOrder: 10,
  ),
  ToolEntry(
    id: 'morse',
    name: '摩尔斯电码',
    description: '文本与摩尔斯电码互转',
    icon: Icons.graphic_eq,
    category: ToolCategory.text,
    builder: (_) => const MorsePage(),
    isOffline: true,
    sortOrder: 11,
  ),
  ToolEntry(
    id: 'rmb_uppercase',
    name: '大小写金额',
    description: '数字金额转中文大写金额',
    icon: Icons.currency_yen,
    category: ToolCategory.calculator,
    builder: (_) => const RmbUppercasePage(),
    isOffline: true,
    sortOrder: 12,
  ),
  ToolEntry(
    id: 'random_string',
    name: '随机字符串',
    description: '按字符集和长度生成随机字符串',
    icon: Icons.password,
    category: ToolCategory.other,
    builder: (_) => const RandomStringPage(),
    isOffline: true,
    sortOrder: 13,
  ),
  ToolEntry(
    id: 'base64_codec',
    name: 'Base64 编解码',
    description: '文本与 Base64 互转',
    icon: Icons.lock_clock,
    category: ToolCategory.text,
    builder: (_) => const Base64CodecPage(),
    isOffline: true,
    sortOrder: 14,
  ),
  ToolEntry(
    id: 'url_codec',
    name: 'URL 编解码',
    description: 'URL 参数编码与解码',
    icon: Icons.link,
    category: ToolCategory.text,
    builder: (_) => const UrlCodecPage(),
    isOffline: true,
    sortOrder: 15,
  ),
  ToolEntry(
    id: 'text_stats',
    name: '字数统计',
    description: '统计字符数、单词数与行数',
    icon: Icons.text_fields,
    category: ToolCategory.text,
    builder: (_) => const TextStatsPage(),
    isOffline: true,
    sortOrder: 16,
  ),
  ToolEntry(
    id: 'text_dedup_sort',
    name: '文本去重/排序',
    description: '去重并按升降序排序文本行',
    icon: Icons.sort,
    category: ToolCategory.text,
    builder: (_) => const TextDedupSortPage(),
    isOffline: true,
    sortOrder: 17,
  ),
  ToolEntry(
    id: 'decision_maker',
    name: '做个决定',
    description: '从自定义选项中随机选择一个结果',
    icon: Icons.psychology,
    category: ToolCategory.daily,
    builder: (_) => const DecisionPage(),
    isOffline: true,
    sortOrder: 18,
  ),
  ToolEntry(
    id: 'unicode_codec',
    name: 'Unicode 编解码',
    description: '文本与 Unicode 转义互转',
    icon: Icons.language,
    category: ToolCategory.text,
    builder: (_) => const UnicodeCodecPage(),
    isOffline: true,
    sortOrder: 19,
  ),
  ToolEntry(
    id: 'text_compare',
    name: '文本对比',
    description: '对比两组文本差异与交集数量',
    icon: Icons.compare_arrows,
    category: ToolCategory.text,
    builder: (_) => const TextComparePage(),
    isOffline: true,
    sortOrder: 20,
  ),
  ToolEntry(
    id: 'fullscreen_clock',
    name: '全屏时钟',
    description: '实时显示时间，支持 24 小时制与秒钟开关',
    icon: Icons.access_time_filled,
    category: ToolCategory.other,
    builder: (_) => const FullscreenClockPage(),
    isOffline: true,
    sortOrder: 21,
  ),
  ToolEntry(
    id: 'eat_what',
    name: '今天吃什么',
    description: '从候选菜品中随机推荐',
    icon: Icons.restaurant,
    category: ToolCategory.other,
    builder: (_) => const EatWhatPage(),
    isOffline: true,
    sortOrder: 22,
  ),
];

final Map<String, ToolEntry> toolIndex = {
  for (final tool in allTools) tool.id: tool,
};

ToolEntry? getToolById(String id) => toolIndex[id];
