import 'dart:math';

/// 指南针逻辑层（纯 Dart）
///
/// 将磁力计 X/Y 原始值转换为角度（0-360）。
class CompassLogic {
  const CompassLogic();

  /// 从磁力计 X/Y 计算方位角（度数，0 = 北，顺时针）
  double headingFromXY(double x, double y) {
    final angle = atan2(x, y) * (180 / pi);
    return (angle + 360) % 360;
  }

  /// 将角度映射为方位文字
  String directionLabel(double heading) {
    const labels = ['北', '东北', '东', '东南', '南', '西南', '西', '西北'];
    final index = ((heading + 22.5) % 360) ~/ 45;
    return labels[index];
  }

  /// 是否需要校准提示（水平磁场分量过小说明可能受干扰）
  bool needsCalibration(double x, double y) {
    final magnitude = sqrt(x * x + y * y);
    return magnitude < 10;
  }
}
