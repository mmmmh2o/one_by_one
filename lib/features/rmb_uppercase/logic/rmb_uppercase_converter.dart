class RmbUppercaseConverter {
  static const List<String> _digits = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];
  static const List<String> _units = ['', '拾', '佰', '仟'];
  static const List<String> _sectionUnits = ['', '万', '亿', '兆'];

  const RmbUppercaseConverter();

  String convert(double amount) {
    if (amount < 0 || amount >= 1e16) {
      return '金额超出支持范围';
    }

    final fenTotal = (amount * 100).round();
    final integerPart = fenTotal ~/ 100;
    final jiao = (fenTotal ~/ 10) % 10;
    final fen = fenTotal % 10;

    final integerText = integerPart == 0 ? '零' : _convertInteger(integerPart);

    final tail = StringBuffer();
    if (jiao == 0 && fen == 0) {
      tail.write('整');
    } else {
      if (jiao > 0) {
        tail.write('${_digits[jiao]}角');
      }
      if (fen > 0) {
        tail.write('${_digits[fen]}分');
      }
    }

    return '$integerText元${tail.toString()}';
  }

  String _convertInteger(int value) {
    final parts = <String>[];
    var sectionIndex = 0;
    var current = value;
    var needZero = false;

    while (current > 0) {
      final section = current % 10000;
      if (section == 0) {
        if (parts.isNotEmpty) needZero = true;
      } else {
        final sectionText = _convertSection(section);
        final prefixZero = needZero ? '零' : '';
        parts.insert(0, '$prefixZero$sectionText${_sectionUnits[sectionIndex]}');
        needZero = section < 1000;
      }
      current ~/= 10000;
      sectionIndex++;
    }

    return parts.join().replaceAll(RegExp(r'零+'), '零').replaceAll(RegExp(r'零$'), '');
  }

  String _convertSection(int section) {
    final out = StringBuffer();
    var unitIndex = 0;
    var current = section;
    var zeroFlag = false;

    while (current > 0) {
      final digit = current % 10;
      if (digit == 0) {
        zeroFlag = out.isNotEmpty;
      } else {
        if (zeroFlag) {
          out.write('零');
          zeroFlag = false;
        }
        out.write(_units[unitIndex]);
        out.write(_digits[digit]);
      }
      unitIndex++;
      current ~/= 10;
    }

    return out.toString().split('').reversed.join();
  }
}
