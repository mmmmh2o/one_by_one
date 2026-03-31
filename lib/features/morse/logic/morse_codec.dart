class MorseCodec {
  static const Map<String, String> _encodeMap = {
    'A': '.-',
    'B': '-...',
    'C': '-.-.',
    'D': '-..',
    'E': '.',
    'F': '..-.',
    'G': '--.',
    'H': '....',
    'I': '..',
    'J': '.---',
    'K': '-.-',
    'L': '.-..',
    'M': '--',
    'N': '-.',
    'O': '---',
    'P': '.--.',
    'Q': '--.-',
    'R': '.-.',
    'S': '...',
    'T': '-',
    'U': '..-',
    'V': '...-',
    'W': '.--',
    'X': '-..-',
    'Y': '-.--',
    'Z': '--..',
    '0': '-----',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
  };

  static final Map<String, String> _decodeMap = {
    for (final entry in _encodeMap.entries) entry.value: entry.key,
  };

  const MorseCodec();

  String encode(String input) {
    final tokens = <String>[];
    for (final rune in input.toUpperCase().runes) {
      final ch = String.fromCharCode(rune);
      if (ch == ' ') {
        tokens.add('/');
        continue;
      }
      tokens.add(_encodeMap[ch] ?? '?');
    }
    return tokens.join(' ');
  }

  String decode(String input) {
    final tokens = input.trim().split(RegExp(r'\s+'));
    final out = StringBuffer();
    for (final token in tokens) {
      if (token == '/') {
        out.write(' ');
        continue;
      }
      out.write(_decodeMap[token] ?? '?');
    }
    return out.toString();
  }
}
