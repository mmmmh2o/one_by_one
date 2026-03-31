/// 纯 RGB 颜色值，零 Flutter 依赖
class RgbColor {
  final int r;
  final int g;
  final int b;

  const RgbColor(this.r, this.g, this.b);

  String toHex() =>
      '#${_hex(r)}${_hex(g)}${_hex(b)}'.toUpperCase();

  static String _hex(int v) => v.toRadixString(16).padLeft(2, '0');

  @override
  String toString() => toHex();
}

/// HSL → RGB 纯数学转换
RgbColor _hslToRgb(double hue, double sat, double light) {
  final c = (1 - (2 * light - 1).abs()) * sat;
  final x = c * (1 - (((hue / 60) % 2) - 1).abs());
  final m = light - c / 2;

  double r1, g1, b1;
  if (hue < 60) {
    r1 = c; g1 = x; b1 = 0;
  } else if (hue < 120) {
    r1 = x; g1 = c; b1 = 0;
  } else if (hue < 180) {
    r1 = 0; g1 = c; b1 = x;
  } else if (hue < 240) {
    r1 = 0; g1 = x; b1 = c;
  } else if (hue < 300) {
    r1 = x; g1 = 0; b1 = c;
  } else {
    r1 = c; g1 = 0; b1 = x;
  }

  return RgbColor(
    ((r1 + m) * 255).round().clamp(0, 255),
    ((g1 + m) * 255).round().clamp(0, 255),
    ((b1 + m) * 255).round().clamp(0, 255),
  );
}

class PaletteGenerator {
  const PaletteGenerator();

  List<RgbColor> generate({required String seed, int count = 6}) {
    final safeCount = count.clamp(3, 10);
    final hash = seed.isEmpty
        ? DateTime.now().millisecondsSinceEpoch
        : seed.hashCode;
    final baseHue = (hash.abs() % 360).toDouble();

    final colors = <RgbColor>[];
    for (var i = 0; i < safeCount; i++) {
      final hue = (baseHue + (360 / safeCount) * i) % 360;
      final sat = (0.55 + (i % 3) * 0.1).clamp(0.35, 0.9);
      final light = (0.42 + (i % 2) * 0.12).clamp(0.3, 0.75);
      colors.add(_hslToRgb(hue, sat, light));
    }
    return colors;
  }
}
