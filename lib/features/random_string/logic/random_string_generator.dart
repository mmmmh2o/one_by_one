import 'dart:math';

class RandomStringGenerator {
  static const String _lower = 'abcdefghijklmnopqrstuvwxyz';
  static const String _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';
  static const String _symbols = '!@#%^&*_-+=';

  final Random _random;

  RandomStringGenerator([Random? random]) : _random = random ?? Random();

  String generate({
    required int length,
    required bool useLower,
    required bool useUpper,
    required bool useDigits,
    required bool useSymbols,
  }) {
    final safeLength = length.clamp(1, 256);
    final pool = StringBuffer();
    if (useLower) pool.write(_lower);
    if (useUpper) pool.write(_upper);
    if (useDigits) pool.write(_digits);
    if (useSymbols) pool.write(_symbols);

    final chars = pool.toString();
    if (chars.isEmpty) {
      return '';
    }

    return List<String>.generate(
      safeLength,
      (_) => chars[_random.nextInt(chars.length)],
    ).join();
  }
}
