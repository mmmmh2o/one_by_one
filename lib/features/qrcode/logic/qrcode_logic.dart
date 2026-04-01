/// 二维码尺寸预设
enum QrSize { small, medium, large }

/// Logic 层：二维码生成参数计算（纯 Dart）
class QrGenerator {
  const QrGenerator();

  /// 将尺寸枚举映射为像素值
  double sizeToPixels(QrSize size) => switch (size) {
        QrSize.small => 160,
        QrSize.medium => 240,
        QrSize.large => 320,
      };

  /// 校验输入文本是否可生成
  bool canGenerate(String text) => text.trim().isNotEmpty;
}
