import 'dart:math';

/// 水平仪逻辑层（纯 Dart）
class LevelLogic {
  const LevelLogic();

  /// 将加速度计数据转换为倾斜角度
  ///
  /// [x] 水平方向加速度
  /// [y] 垂直方向加速度
  /// 返回倾斜角度（度），0 = 完全水平
  double tiltAngle(double x, double y) {
    final angle = atan2(x, y) * (180 / pi);
    return angle.clamp(-90, 90);
  }

  /// 判断是否水平（偏差 < 阈值度数）
  bool isLevel(double x, double y, {double threshold = 1.5}) {
    return tiltAngle(x, y).abs() < threshold;
  }

  /// 水平偏移比例（-1.0 ~ 1.0，用于 UI 泡泡位置）
  double offsetX(double x, double y, {double maxAngle = 45}) {
    final angle = tiltAngle(x, y);
    return (angle / maxAngle).clamp(-1.0, 1.0);
  }
}
