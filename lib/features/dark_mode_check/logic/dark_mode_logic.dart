/// 深色模式检测 — 纯 Dart 逻辑层
///
/// 亮度分析、对比度计算、WCAG 合规检测
import 'dart:math';

class DarkModeEngine {
  const DarkModeEngine();

  /// 从 Hex 颜色解析 RGB
  ({int r, int g, int b}) parseColor(String hex) {
    final clean = hex.replaceAll('#', '').replaceAll('0x', '');
    final value = int.parse(clean.length == 6 ? 'ff$clean' : clean, radix: 16);
    return (
      r: (value >> 16) & 0xFF,
      g: (value >> 8) & 0xFF,
      b: value & 0xFF,
    );
  }

  /// 相对亮度 (WCAG 2.0)
  double relativeLuminance(int r, int g, int b) {
    final sR = r / 255.0;
    final sG = g / 255.0;
    final sB = b / 255.0;
    final lR = sR <= 0.03928 ? sR / 12.92 : pow((sR + 0.055) / 1.055, 2.4);
    final lG = sG <= 0.03928 ? sG / 12.92 : pow((sG + 0.055) / 1.055, 2.4);
    final lB = sB <= 0.03928 ? sB / 12.92 : pow((sB + 0.055) / 1.055, 2.4);
    return 0.2126 * lR + 0.7152 * lG + 0.0722 * lB;
  }

  /// 对比度 (WCAG 2.0)
  double contrastRatio(double lum1, double lum2) {
    final lighter = max(lum1, lum2);
    final darker = min(lum1, lum2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// WCAG 合规等级
  String wcagLevel(double ratio) {
    if (ratio >= 7) return 'AAA ✅';
    if (ratio >= 4.5) return 'AA ✅';
    if (ratio >= 3) return 'AA 大字 ⚠️';
    return '不合规 ❌';
  }

  /// 判断颜色是否为深色
  bool isDarkColor(int r, int g, int b) {
    return relativeLuminance(r, g, b) < 0.5;
  }

  /// 推荐的前景色（黑或白）
  ({int r, int g, int b}) recommendedForeground(int r, int g, int b) {
    return isDarkColor(r, g, b)
        ? (r: 255, g: 255, b: 255)
        : (r: 0, g: 0, b: 0);
  }

  /// 色温描述
  String colorTemperature(int r, int g, int b) {
    if (r > b + 50 && g > b + 20) return '暖色调 🔥';
    if (b > r + 50) return '冷色调 ❄️';
    if (r > 200 && g > 200 && b > 200) return '亮色 🌟';
    if (r < 50 && g < 50 && b < 50) return '暗色 🌑';
    return '中性色 ⚖️';
  }

  /// RGB 转 Hex
  String toHex(int r, int g, int b) {
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  /// HSL 转 RGB
  ({int r, int g, int b}) hslToRgb(double h, double s, double l) {
    h = h % 360;
    final c = (1 - (2 * l - 1).abs()) * s;
    final x = c * (1 - ((h / 60) % 2 - 1).abs());
    final m = l - c / 2;
    double r1, g1, b1;
    if (h < 60) { r1 = c; g1 = x; b1 = 0; }
    else if (h < 120) { r1 = x; g1 = c; b1 = 0; }
    else if (h < 180) { r1 = 0; g1 = c; b1 = x; }
    else if (h < 240) { r1 = 0; g1 = x; b1 = c; }
    else if (h < 300) { r1 = x; g1 = 0; b1 = c; }
    else { r1 = c; g1 = 0; b1 = x; }
    return (
      r: ((r1 + m) * 255).round().clamp(0, 255),
      g: ((g1 + m) * 255).round().clamp(0, 255),
      b: ((b1 + m) * 255).round().clamp(0, 255),
    );
  }
}
