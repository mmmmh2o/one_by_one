/// 量角器 — 纯 Dart 逻辑层
///
/// 角度计算与单位转换
import 'dart:math';

class ProtractorEngine {
  const ProtractorEngine();

  /// 从加速度计数据计算倾斜角度（度数）
  double tiltFromAccelerometer(double x, double y) {
    return atan2(x, y) * 180 / pi;
  }

  /// 度数转弧度
  double degToRad(double degrees) => degrees * pi / 180;

  /// 弧度转度数
  double radToDeg(double radians) => radians * 180 / pi;

  /// 格式化角度显示
  String formatDegrees(double degrees) {
    final d = degrees % 360;
    return '${d.toStringAsFixed(1)}°';
  }

  /// 常用角度名称
  String? specialAngleName(double degrees) {
    final d = (degrees % 360).round().abs();
    return switch (d) {
      0 => '零角',
      30 => '三十度',
      45 => '四十五度',
      60 => '六十度',
      90 => '直角',
      120 => '一百二十度',
      135 => '一百三十五度',
      150 => '一百五十度',
      180 => '平角',
      270 => '二百七十度',
      360 => '一周',
      _ => null,
    };
  }
}
