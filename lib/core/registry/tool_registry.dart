import 'package:flutter/material.dart';

import '../../models/tool_entry.dart';
export '../../models/tool_entry.dart' show DeferredWidget;

// ═══════════════════════════════════════════════════════════════════════════
// Deferred imports — 所有工具页面按需加载，减少启动时的库编译/链接开销
// ═══════════════════════════════════════════════════════════════════════════

import '../../features/ruler/ruler_page.dart' deferred as ruler;
import '../../features/random/random_page.dart' deferred as random;
import '../../features/dice/dice_page.dart' deferred as dice;
import '../../features/unit_converter/unit_converter_page.dart' deferred as unit_converter;
import '../../features/base_converter/base_converter_page.dart' deferred as base_converter;
import '../../features/date_calculator/date_calculator_page.dart' deferred as date_calculator;
import '../../features/calculator/calculator_page.dart' deferred as calculator;
import '../../features/bmi/bmi_page.dart' deferred as bmi;
import '../../features/coin/coin_page.dart' deferred as coin;
import '../../features/json_formatter/json_formatter_page.dart' deferred as json_formatter;
import '../../features/morse/morse_page.dart' deferred as morse;
import '../../features/rmb_uppercase/rmb_uppercase_page.dart' deferred as rmb_uppercase;
import '../../features/random_string/random_string_page.dart' deferred as random_string;
import '../../features/base64_codec/base64_codec_page.dart' deferred as base64_codec;
import '../../features/url_codec/url_codec_page.dart' deferred as url_codec;
import '../../features/text_stats/text_stats_page.dart' deferred as text_stats;
import '../../features/text_dedup_sort/text_dedup_sort_page.dart' deferred as text_dedup_sort;
import '../../features/decision_maker/decision_page.dart' deferred as decision;
import '../../features/unicode_codec/unicode_codec_page.dart' deferred as unicode_codec;
import '../../features/text_compare/text_compare_page.dart' deferred as text_compare;
import '../../features/fullscreen_clock/fullscreen_clock_page.dart' deferred as fullscreen_clock;
import '../../features/eat_what/eat_what_page.dart' deferred as eat_what;
import '../../features/regex_tester/regex_tester_page.dart' deferred as regex_tester;
import '../../features/palette_generator/palette_generator_page.dart' deferred as palette_generator;
import '../../features/qrcode/qrcode_page.dart' deferred as qrcode;
import '../../features/compass/compass_page.dart' deferred as compass;
import '../../features/flashlight/flashlight_page.dart' deferred as flashlight;
import '../../features/device_info/device_info_page.dart' deferred as device_info;
import '../../features/image_compress/image_compress_page.dart' deferred as image_compress;
import '../../features/level/level_page.dart' deferred as level;
import '../../features/led_banner/led_banner_page.dart' deferred as led_banner;
import '../../features/loan_calculator/loan_calculator_page.dart' deferred as loan_calculator;
import '../../features/tax_calculator/tax_calculator_page.dart' deferred as tax_calculator;
import '../../features/simplified_convert/simplified_convert_page.dart' deferred as simplified_convert;
import '../../features/speed_test/speed_test_page.dart' deferred as speed_test;
import '../../features/code_formatter/code_formatter_page.dart' deferred as code_formatter;
import '../../features/protractor/protractor_page.dart' deferred as protractor;
import '../../features/dark_mode_check/dark_mode_check_page.dart' deferred as dark_mode_check;
import '../../features/text_encrypt/text_encrypt_page.dart' deferred as text_encrypt;

// ── Helper: 构造延迟加载的 builder ──────────────────────────────────────

WidgetBuilder _deferred(
  Future<void> Function() loadLibrary,
  Widget Function() createWidget,
) {
  return (_) => DeferredWidget(
        loader: loadLibrary,
        builder: (_) => createWidget(),
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// 工具列表
// ═══════════════════════════════════════════════════════════════════════════

final List<ToolEntry> allTools = [
  ToolEntry(
    id: 'ruler',
    name: '尺子',
    description: '屏幕尺子，厘米/英寸实时显示',
    icon: Icons.straighten,
    category: ToolCategory.daily,
    builder: _deferred(ruler.loadLibrary, () => ruler.RulerPage()),
    loadLibrary: ruler.loadLibrary,
    isOffline: true,
    sortOrder: 1,
  ),
  ToolEntry(
    id: 'random_number',
    name: '随机数',
    description: '生成任意范围的随机数',
    icon: Icons.shuffle,
    category: ToolCategory.other,
    builder: _deferred(random.loadLibrary, () => random.RandomPage()),
    loadLibrary: random.loadLibrary,
    isOffline: true,
    sortOrder: 2,
  ),
  ToolEntry(
    id: 'dice',
    name: '掷骰子',
    description: '支持多颗骰子与动画',
    icon: Icons.casino,
    category: ToolCategory.other,
    builder: _deferred(dice.loadLibrary, () => dice.DicePage()),
    loadLibrary: dice.loadLibrary,
    isOffline: true,
    sortOrder: 3,
  ),
  ToolEntry(
    id: 'unit_converter',
    name: '单位换算',
    description: '长度/重量/温度等单位互转',
    icon: Icons.swap_horiz,
    category: ToolCategory.calculator,
    builder: _deferred(unit_converter.loadLibrary, () => unit_converter.UnitConverterPage()),
    loadLibrary: unit_converter.loadLibrary,
    isOffline: true,
    sortOrder: 4,
  ),
  ToolEntry(
    id: 'calculator',
    name: '计算器',
    description: '基础四则运算，支持小数',
    icon: Icons.calculate,
    category: ToolCategory.calculator,
    builder: _deferred(calculator.loadLibrary, () => calculator.CalculatorPage()),
    loadLibrary: calculator.loadLibrary,
    isOffline: true,
    sortOrder: 5,
  ),
  ToolEntry(
    id: 'coin',
    name: '抛硬币',
    description: '随机正反面并统计次数',
    icon: Icons.toll,
    category: ToolCategory.other,
    builder: _deferred(coin.loadLibrary, () => coin.CoinPage()),
    loadLibrary: coin.loadLibrary,
    isOffline: true,
    sortOrder: 6,
  ),
  ToolEntry(
    id: 'base_converter',
    name: '进制转换',
    description: '2/8/10/16/32/36 进制互转',
    icon: Icons.numbers,
    category: ToolCategory.calculator,
    builder: _deferred(base_converter.loadLibrary, () => base_converter.BaseConverterPage()),
    loadLibrary: base_converter.loadLibrary,
    isOffline: true,
    sortOrder: 7,
  ),
  ToolEntry(
    id: 'date_calculator',
    name: '日期计算',
    description: '计算两个日期之间的天数与周数',
    icon: Icons.date_range,
    category: ToolCategory.daily,
    builder: _deferred(date_calculator.loadLibrary, () => date_calculator.DateCalculatorPage()),
    loadLibrary: date_calculator.loadLibrary,
    isOffline: true,
    sortOrder: 8,
  ),
  ToolEntry(
    id: 'bmi',
    name: 'BMI 计算',
    description: '根据身高体重计算 BMI 与分级',
    icon: Icons.monitor_weight,
    category: ToolCategory.calculator,
    builder: _deferred(bmi.loadLibrary, () => bmi.BmiPage()),
    loadLibrary: bmi.loadLibrary,
    isOffline: true,
    sortOrder: 9,
  ),
  ToolEntry(
    id: 'json_formatter',
    name: 'JSON 格式化',
    description: 'JSON 文本格式化与压缩',
    icon: Icons.data_object,
    category: ToolCategory.text,
    builder: _deferred(json_formatter.loadLibrary, () => json_formatter.JsonFormatterPage()),
    loadLibrary: json_formatter.loadLibrary,
    isOffline: true,
    sortOrder: 10,
  ),
  ToolEntry(
    id: 'morse',
    name: '摩尔斯电码',
    description: '文本与摩尔斯电码互转',
    icon: Icons.graphic_eq,
    category: ToolCategory.text,
    builder: _deferred(morse.loadLibrary, () => morse.MorsePage()),
    loadLibrary: morse.loadLibrary,
    isOffline: true,
    sortOrder: 11,
  ),
  ToolEntry(
    id: 'rmb_uppercase',
    name: '大小写金额',
    description: '数字金额转中文大写金额',
    icon: Icons.currency_yen,
    category: ToolCategory.calculator,
    builder: _deferred(rmb_uppercase.loadLibrary, () => rmb_uppercase.RmbUppercasePage()),
    loadLibrary: rmb_uppercase.loadLibrary,
    isOffline: true,
    sortOrder: 12,
  ),
  ToolEntry(
    id: 'random_string',
    name: '随机字符串',
    description: '按字符集和长度生成随机字符串',
    icon: Icons.password,
    category: ToolCategory.other,
    builder: _deferred(random_string.loadLibrary, () => random_string.RandomStringPage()),
    loadLibrary: random_string.loadLibrary,
    isOffline: true,
    sortOrder: 13,
  ),
  ToolEntry(
    id: 'base64_codec',
    name: 'Base64 编解码',
    description: '文本与 Base64 互转',
    icon: Icons.lock_clock,
    category: ToolCategory.text,
    builder: _deferred(base64_codec.loadLibrary, () => base64_codec.Base64CodecPage()),
    loadLibrary: base64_codec.loadLibrary,
    isOffline: true,
    sortOrder: 14,
  ),
  ToolEntry(
    id: 'url_codec',
    name: 'URL 编解码',
    description: 'URL 参数编码与解码',
    icon: Icons.link,
    category: ToolCategory.text,
    builder: _deferred(url_codec.loadLibrary, () => url_codec.UrlCodecPage()),
    loadLibrary: url_codec.loadLibrary,
    isOffline: true,
    sortOrder: 15,
  ),
  ToolEntry(
    id: 'text_stats',
    name: '字数统计',
    description: '统计字符数、单词数与行数',
    icon: Icons.text_fields,
    category: ToolCategory.text,
    builder: _deferred(text_stats.loadLibrary, () => text_stats.TextStatsPage()),
    loadLibrary: text_stats.loadLibrary,
    isOffline: true,
    sortOrder: 16,
  ),
  ToolEntry(
    id: 'text_dedup_sort',
    name: '文本去重/排序',
    description: '去重并按升降序排序文本行',
    icon: Icons.sort,
    category: ToolCategory.text,
    builder: _deferred(text_dedup_sort.loadLibrary, () => text_dedup_sort.TextDedupSortPage()),
    loadLibrary: text_dedup_sort.loadLibrary,
    isOffline: true,
    sortOrder: 17,
  ),
  ToolEntry(
    id: 'decision_maker',
    name: '做个决定',
    description: '从自定义选项中随机选择一个结果',
    icon: Icons.psychology,
    category: ToolCategory.daily,
    builder: _deferred(decision.loadLibrary, () => decision.DecisionPage()),
    loadLibrary: decision.loadLibrary,
    isOffline: true,
    sortOrder: 18,
  ),
  ToolEntry(
    id: 'unicode_codec',
    name: 'Unicode 编解码',
    description: '文本与 Unicode 转义互转',
    icon: Icons.language,
    category: ToolCategory.text,
    builder: _deferred(unicode_codec.loadLibrary, () => unicode_codec.UnicodeCodecPage()),
    loadLibrary: unicode_codec.loadLibrary,
    isOffline: true,
    sortOrder: 19,
  ),
  ToolEntry(
    id: 'text_compare',
    name: '文本对比',
    description: '对比两组文本差异与交集数量',
    icon: Icons.compare_arrows,
    category: ToolCategory.text,
    builder: _deferred(text_compare.loadLibrary, () => text_compare.TextComparePage()),
    loadLibrary: text_compare.loadLibrary,
    isOffline: true,
    sortOrder: 20,
  ),
  ToolEntry(
    id: 'fullscreen_clock',
    name: '全屏时钟',
    description: '实时显示时间，支持 24 小时制与秒钟开关',
    icon: Icons.access_time_filled,
    category: ToolCategory.other,
    builder: _deferred(fullscreen_clock.loadLibrary, () => fullscreen_clock.FullscreenClockPage()),
    loadLibrary: fullscreen_clock.loadLibrary,
    isOffline: true,
    sortOrder: 21,
  ),
  ToolEntry(
    id: 'eat_what',
    name: '今天吃什么',
    description: '从候选菜品中随机推荐',
    icon: Icons.restaurant,
    category: ToolCategory.other,
    builder: _deferred(eat_what.loadLibrary, () => eat_what.EatWhatPage()),
    loadLibrary: eat_what.loadLibrary,
    isOffline: true,
    sortOrder: 22,
  ),
  ToolEntry(
    id: 'regex_tester',
    name: '正则测试器',
    description: '测试正则表达式并查看匹配结果',
    icon: Icons.rule,
    category: ToolCategory.thirdParty,
    builder: _deferred(regex_tester.loadLibrary, () => regex_tester.RegexTesterPage()),
    loadLibrary: regex_tester.loadLibrary,
    isOffline: true,
    sortOrder: 23,
  ),
  ToolEntry(
    id: 'palette_generator',
    name: '配色方案生成',
    description: '根据种子词生成多组可复制色板',
    icon: Icons.palette,
    category: ToolCategory.other,
    builder: _deferred(palette_generator.loadLibrary, () => palette_generator.PaletteGeneratorPage()),
    loadLibrary: palette_generator.loadLibrary,
    isOffline: true,
    sortOrder: 24,
  ),
  ToolEntry(
    id: 'qrcode',
    name: '二维码',
    description: '生成与扫描二维码',
    icon: Icons.qr_code_2,
    category: ToolCategory.daily,
    builder: _deferred(qrcode.loadLibrary, () => qrcode.QrcodePage()),
    loadLibrary: qrcode.loadLibrary,
    isOffline: false,
    sortOrder: 25,
  ),
  ToolEntry(
    id: 'compass',
    name: '指南针',
    description: '实时方位指示与磁场检测',
    icon: Icons.explore,
    category: ToolCategory.device,
    builder: _deferred(compass.loadLibrary, () => compass.CompassPage()),
    loadLibrary: compass.loadLibrary,
    isOffline: true,
    sortOrder: 26,
  ),
  ToolEntry(
    id: 'flashlight',
    name: '手电筒',
    description: '开关手电筒照明',
    icon: Icons.flashlight_on_rounded,
    category: ToolCategory.device,
    builder: _deferred(flashlight.loadLibrary, () => flashlight.FlashlightPage()),
    loadLibrary: flashlight.loadLibrary,
    isOffline: true,
    sortOrder: 27,
  ),
  ToolEntry(
    id: 'device_info',
    name: '设备信息',
    description: '查看手机硬件与系统信息',
    icon: Icons.phone_android_rounded,
    category: ToolCategory.device,
    builder: _deferred(device_info.loadLibrary, () => device_info.DeviceInfoPage()),
    loadLibrary: device_info.loadLibrary,
    isOffline: true,
    sortOrder: 28,
  ),
  ToolEntry(
    id: 'image_compress',
    name: '图片压缩',
    description: '调整质量与尺寸压缩图片',
    icon: Icons.compress,
    category: ToolCategory.image,
    builder: _deferred(image_compress.loadLibrary, () => image_compress.ImageCompressPage()),
    loadLibrary: image_compress.loadLibrary,
    isOffline: true,
    sortOrder: 29,
  ),
  ToolEntry(
    id: 'level',
    name: '水平仪',
    description: '利用加速度计检测桌面是否水平',
    icon: Icons.bubble_chart,
    category: ToolCategory.device,
    builder: _deferred(level.loadLibrary, () => level.LevelPage()),
    loadLibrary: level.loadLibrary,
    isOffline: true,
    sortOrder: 30,
  ),
  ToolEntry(
    id: 'led_banner',
    name: 'LED 弹幕',
    description: '全屏滚动文字，支持速度与字号',
    icon: Icons.developer_board,
    category: ToolCategory.daily,
    builder: _deferred(led_banner.loadLibrary, () => led_banner.LedBannerPage()),
    loadLibrary: led_banner.loadLibrary,
    isOffline: true,
    sortOrder: 31,
  ),
  ToolEntry(
    id: 'loan_calculator',
    name: '房贷计算',
    description: '等额本息 / 等额本金房贷计算',
    icon: Icons.home_work,
    category: ToolCategory.calculator,
    builder: _deferred(loan_calculator.loadLibrary, () => loan_calculator.LoanCalculatorPage()),
    loadLibrary: loan_calculator.loadLibrary,
    isOffline: true,
    sortOrder: 32,
  ),
  ToolEntry(
    id: 'tax_calculator',
    name: '个税计算',
    description: '综合所得个人所得税计算',
    icon: Icons.receipt_long,
    category: ToolCategory.calculator,
    builder: _deferred(tax_calculator.loadLibrary, () => tax_calculator.TaxCalculatorPage()),
    loadLibrary: tax_calculator.loadLibrary,
    isOffline: true,
    sortOrder: 33,
  ),
  ToolEntry(
    id: 'simplified_convert',
    name: '繁简转换',
    description: '简体与繁体中文互转',
    icon: Icons.translate,
    category: ToolCategory.text,
    builder: _deferred(simplified_convert.loadLibrary, () => simplified_convert.SimplifiedConvertPage()),
    loadLibrary: simplified_convert.loadLibrary,
    isOffline: true,
    sortOrder: 34,
  ),
  ToolEntry(
    id: 'speed_test',
    name: '网速测试',
    description: '测量当前网络下载/上传带宽与延迟',
    icon: Icons.network_check,
    category: ToolCategory.daily,
    builder: _deferred(speed_test.loadLibrary, () => speed_test.SpeedTestPage()),
    loadLibrary: speed_test.loadLibrary,
    isOffline: false,
    sortOrder: 35,
  ),
  ToolEntry(
    id: 'text_encrypt',
    name: '文字加密',
    description: 'Base64/ROT13/凯撒密码等加密解密',
    icon: Icons.enhanced_encryption,
    category: ToolCategory.text,
    builder: _deferred(text_encrypt.loadLibrary, () => text_encrypt.TextEncryptPage()),
    loadLibrary: text_encrypt.loadLibrary,
    isOffline: true,
    sortOrder: 36,
  ),
  ToolEntry(
    id: 'code_formatter',
    name: '代码格式化',
    description: 'JSON/HTML/CSS/JS 格式化与压缩',
    icon: Icons.code,
    category: ToolCategory.text,
    builder: _deferred(code_formatter.loadLibrary, () => code_formatter.CodeFormatterPage()),
    loadLibrary: code_formatter.loadLibrary,
    isOffline: true,
    sortOrder: 37,
  ),
  ToolEntry(
    id: 'protractor',
    name: '量角器',
    description: '实时测量手机倾斜角度',
    icon: Icons.architecture,
    category: ToolCategory.device,
    builder: _deferred(protractor.loadLibrary, () => protractor.ProtractorPage()),
    loadLibrary: protractor.loadLibrary,
    isOffline: true,
    sortOrder: 38,
  ),
  ToolEntry(
    id: 'dark_mode_check',
    name: '色彩检测',
    description: 'WCAG 对比度检测与深色模式分析',
    icon: Icons.contrast,
    category: ToolCategory.daily,
    builder: _deferred(dark_mode_check.loadLibrary, () => dark_mode_check.DarkModeCheckPage()),
    loadLibrary: dark_mode_check.loadLibrary,
    isOffline: true,
    sortOrder: 39,
  ),
];

/// 工具索引 Map，按 id 快速查找
final Map<String, ToolEntry> toolIndex = {
  for (final tool in allTools) tool.id: tool,
};

/// 根据 id 获取工具条目
ToolEntry? getToolById(String id) => toolIndex[id];
