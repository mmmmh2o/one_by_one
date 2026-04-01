/// LED 弹幕逻辑层（纯 Dart）
class LedBannerLogic {
  const LedBannerLogic();

  /// 速度预设（毫秒 / 像素）
  static const speeds = <LedSpeed, double>{
    LedSpeed.slow: 0.8,
    LedSpeed.medium: 1.5,
    LedSpeed.fast: 3.0,
  };

  /// 字号预设
  static const fontSizes = <LedFontSize, double>{
    LedFontSize.small: 24,
    LedFontSize.medium: 48,
    LedFontSize.large: 72,
  };

  /// 是否可以开始滚动
  bool canStart(String text) => text.trim().isNotEmpty;

  /// 文本归一化（去除多余空白）
  String normalize(String text) => text.trim();
}

enum LedSpeed { slow, medium, fast }

enum LedFontSize { small, medium, large }
