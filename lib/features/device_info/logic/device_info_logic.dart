/// 设备信息逻辑层（纯 Dart）
///
/// 格式化和整理设备信息字段。
class DeviceInfoLogic {
  const DeviceInfoLogic();

  /// 将字节数转为可读格式
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// 格式化 Android SDK 版本为 Android 版本名
  String androidVersionName(int sdkInt) {
    const versions = {
      24: 'Android 7.0',
      25: 'Android 7.1',
      26: 'Android 8.0',
      27: 'Android 8.1',
      28: 'Android 9',
      29: 'Android 10',
      30: 'Android 11',
      31: 'Android 12',
      32: 'Android 12L',
      33: 'Android 13',
      34: 'Android 14',
      35: 'Android 15',
      36: 'Android 16',
    };
    return versions[sdkInt] ?? 'Android (SDK $sdkInt)';
  }
}
