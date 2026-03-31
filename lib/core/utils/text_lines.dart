/// 文本行工具扩展
extension TextLines on String {
  /// 按换行符分割，过滤空行
  List<String> get nonEmptyLines =>
      split('\n').where((l) => l.trim().isNotEmpty).toList();

  /// 按换行符分割，trim 每行
  List<String> get trimmedLines =>
      split('\n').map((l) => l.trim()).toList();

  /// 按换行符分割，trim 后过滤空行
  List<String> get nonEmptyTrimmedLines =>
      split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  /// 非空行数量
  int get nonEmptyLineCount => nonEmptyLines.length;
}
