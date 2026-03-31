import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/length_converter.dart';

class UnitConverterState {
  final double input;
  final LengthUnit from;
  final LengthUnit to;
  final double output;

  const UnitConverterState({
    this.input = 1.0,
    this.from = LengthUnit.meter,
    this.to = LengthUnit.centimeter,
    this.output = 100.0,
  });

  UnitConverterState copyWith({double? input, LengthUnit? from, LengthUnit? to, double? output}) {
    return UnitConverterState(
      input: input ?? this.input,
      from: from ?? this.from,
      to: to ?? this.to,
      output: output ?? this.output,
    );
  }
}

class UnitConverterNotifier extends StateNotifier<UnitConverterState> {
  UnitConverterNotifier() : super(const UnitConverterState());

  final _converter = LengthConverter();

  void setInput(double value) {
    _recalculate(input: value);
  }

  void setFrom(LengthUnit unit) {
    _recalculate(from: unit);
  }

  void setTo(LengthUnit unit) {
    _recalculate(to: unit);
  }

  void swapUnits() {
    _recalculate(from: state.to, to: state.from);
  }

  void _recalculate({double? input, LengthUnit? from, LengthUnit? to}) {
    final nextInput = input ?? state.input;
    final nextFrom = from ?? state.from;
    final nextTo = to ?? state.to;
    final output = _converter.convert(value: nextInput, from: nextFrom, to: nextTo);
    state = state.copyWith(input: nextInput, from: nextFrom, to: nextTo, output: output);
  }
}

final unitConverterProvider =
    StateNotifierProvider<UnitConverterNotifier, UnitConverterState>(
  (ref) => UnitConverterNotifier(),
);
