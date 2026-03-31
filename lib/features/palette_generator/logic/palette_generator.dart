import 'dart:ui';

class PaletteGenerator {
  const PaletteGenerator();

  List<Color> generate({required String seed, int count = 6}) {
    final safeCount = count.clamp(3, 10);
    final hash = seed.isEmpty ? DateTime.now().millisecondsSinceEpoch : seed.hashCode;
    final baseHue = (hash.abs() % 360).toDouble();

    final colors = <Color>[];
    for (var i = 0; i < safeCount; i++) {
      final hue = (baseHue + (360 / safeCount) * i) % 360;
      final sat = 0.55 + (i % 3) * 0.1;
      final light = 0.42 + (i % 2) * 0.12;
      final hsl = HSLColor.fromAHSL(1, hue, sat.clamp(0.35, 0.9), light.clamp(0.3, 0.75));
      colors.add(hsl.toColor());
    }
    return colors;
  }

  String toHex(Color color) {
    final r = color.red.toRadixString(16).padLeft(2, '0').toUpperCase();
    final g = color.green.toRadixString(16).padLeft(2, '0').toUpperCase();
    final b = color.blue.toRadixString(16).padLeft(2, '0').toUpperCase();
    return '#$r$g$b';
  }
}
