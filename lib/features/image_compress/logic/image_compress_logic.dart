import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// 图片压缩逻辑层（纯 Dart）
class ImageCompressLogic {
  const ImageCompressLogic();

  /// 压缩图片
  ///
  /// [input] 原始图片字节
  /// [quality] JPEG 质量 1-100
  /// [maxWidth] 最大宽度（0 = 不缩放）
  /// 返回压缩后的 JPEG 字节
  Uint8List compress(Uint8List input, {int quality = 80, int maxWidth = 0}) {
    final image = img.decodeImage(input);
    if (image == null) return input;

    img.Image target = image;

    if (maxWidth > 0 && image.width > maxWidth) {
      target = img.copyResize(image, width: maxWidth);
    }

    final encoded = img.encodeJpg(target, quality: quality);
    return Uint8List.fromList(encoded);
  }

  /// 计算压缩率
  double compressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0;
    return (1 - compressedSize / originalSize) * 100;
  }

  /// 格式化文件大小
  String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
