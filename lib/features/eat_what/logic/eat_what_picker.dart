import 'dart:math';

class EatWhatPicker {
  final Random _random;

  EatWhatPicker([Random? random]) : _random = random ?? Random();

  String pick(List<String> options) {
    if (options.isEmpty) return '今天先喝水';
    return options[_random.nextInt(options.length)];
  }
}
