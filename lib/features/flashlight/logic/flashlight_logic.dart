/// 手电筒逻辑层（纯 Dart）
///
/// 封装手电筒状态枚举与校验逻辑。
class FlashlightLogic {
  const FlashlightLogic();

  /// 检查是否支持手电筒（平台层面在 Provider 处理）
  bool isSupported(bool platformSupported) => platformSupported;
}

/// 手电筒状态
enum FlashlightStatus { off, on, unsupported }
