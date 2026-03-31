import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/coin_flipper.dart';

class CoinState {
  final CoinFlipResult? lastResult;
  final int headsCount;
  final int tailsCount;

  const CoinState({
    this.lastResult,
    this.headsCount = 0,
    this.tailsCount = 0,
  });

  CoinState copyWith({
    CoinFlipResult? lastResult,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinState(
      lastResult: lastResult ?? this.lastResult,
      headsCount: headsCount ?? this.headsCount,
      tailsCount: tailsCount ?? this.tailsCount,
    );
  }
}

class CoinNotifier extends StateNotifier<CoinState> {
  CoinNotifier() : super(const CoinState());

  final _flipper = CoinFlipper();

  void flip() {
    final result = _flipper.flip();
    if (result.side == CoinSide.heads) {
      state = state.copyWith(
        lastResult: result,
        headsCount: state.headsCount + 1,
      );
      return;
    }
    state = state.copyWith(
      lastResult: result,
      tailsCount: state.tailsCount + 1,
    );
  }

  void resetStats() {
    state = const CoinState();
  }
}

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>(
  (ref) => CoinNotifier(),
);
