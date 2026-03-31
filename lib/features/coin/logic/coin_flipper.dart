import 'dart:math';

enum CoinSide { heads, tails }

class CoinFlipResult {
  final CoinSide side;
  final DateTime at;

  const CoinFlipResult({required this.side, required this.at});
}

class CoinFlipper {
  final Random _random;

  CoinFlipper([Random? random]) : _random = random ?? Random();

  CoinFlipResult flip() {
    final side = _random.nextBool() ? CoinSide.heads : CoinSide.tails;
    return CoinFlipResult(side: side, at: DateTime.now());
  }
}
