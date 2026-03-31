import 'package:flutter/material.dart';

TextStyle? scaledTextStyle(TextStyle? base, double scale) {
  if (base == null) {
    return null;
  }
  return base.copyWith(fontSize: (base.fontSize ?? 14) * scale);
}
