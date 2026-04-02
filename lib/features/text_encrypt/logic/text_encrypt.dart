/// 文字加密/解密 — 纯 Dart 逻辑层
///
/// 支持算法：Base64、ROT13、Caesar 密码、Hex 编码
import 'dart:convert';
import 'dart:math';

enum CipherType {
  base64('Base64'),
  rot13('ROT13'),
  caesar('凯撒密码'),
  hex('Hex 编码'),
  reverse('字符串翻转'),
  atbash('Atbash 密码');

  const CipherType(this.label);
  final String label;
}

class TextEncryptEngine {
  const TextEncryptEngine();

  /// 加密
  String encrypt(String input, CipherType type, {int caesarShift = 3}) {
    switch (type) {
      case CipherType.base64:
        return base64Encode(utf8.encode(input));
      case CipherType.rot13:
        return _rotN(input, 13);
      case CipherType.caesar:
        return _rotN(input, caesarShift);
      case CipherType.hex:
        return _toHex(input);
      case CipherType.reverse:
        return input.runes.reversed.map(String.fromCharCode).join();
      case CipherType.atbash:
        return _atbash(input);
    }
  }

  /// 解密
  String decrypt(String input, CipherType type, {int caesarShift = 3}) {
    switch (type) {
      case CipherType.base64:
        try {
          return utf8.decode(base64Decode(input));
        } catch (_) {
          return '解码失败：输入不是有效的 Base64';
        }
      case CipherType.rot13:
        return _rotN(input, 13); // ROT13 自逆
      case CipherType.caesar:
        return _rotN(input, -caesarShift);
      case CipherType.hex:
        return _fromHex(input);
      case CipherType.reverse:
        return input.runes.reversed.map(String.fromCharCode).join();
      case CipherType.atbash:
        return _atbash(input); // Atbash 自逆
    }
  }

  /// ROT-N 位移（仅影响字母）
  String _rotN(String input, int n) {
    final buf = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 65 && rune <= 90) {
        // A-Z
        buf.writeCharCode(((rune - 65 + n) % 26 + 26) % 26 + 65);
      } else if (rune >= 97 && rune <= 122) {
        // a-z
        buf.writeCharCode(((rune - 97 + n) % 26 + 26) % 26 + 97);
      } else {
        buf.writeCharCode(rune);
      }
    }
    return buf.toString();
  }

  /// Atbash 密码 (A↔Z, B↔Y, ...)
  String _atbash(String input) {
    final buf = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 65 && rune <= 90) {
        buf.writeCharCode(90 - (rune - 65));
      } else if (rune >= 97 && rune <= 122) {
        buf.writeCharCode(122 - (rune - 97));
      } else {
        buf.writeCharCode(rune);
      }
    }
    return buf.toString();
  }

  /// 文本 → Hex
  String _toHex(String input) {
    return input.runes.map((r) => r.toRadixString(16).padLeft(2, '0')).join(' ');
  }

  /// Hex → 文本
  String _fromHex(String input) {
    try {
      final parts = input.trim().split(RegExp(r'[\s,]+'));
      return parts.map((h) => String.fromCharCode(int.parse(h, radix: 16))).join();
    } catch (_) {
      return '解码失败：输入不是有效的 Hex';
    }
  }
}
