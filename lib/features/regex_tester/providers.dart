import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/regex_tester.dart';

class RegexTesterState {
  final String pattern;
  final String input;
  final bool caseSensitive;
  final bool multiLine;
  final bool dotAll;
  final RegexTestResult result;

  const RegexTesterState({
    this.pattern = '',
    this.input = '',
    this.caseSensitive = true,
    this.multiLine = false,
    this.dotAll = false,
    this.result = const RegexTestResult(),
  });

  RegexTesterState copyWith({
    String? pattern,
    String? input,
    bool? caseSensitive,
    bool? multiLine,
    bool? dotAll,
    RegexTestResult? result,
  }) {
    return RegexTesterState(
      pattern: pattern ?? this.pattern,
      input: input ?? this.input,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      multiLine: multiLine ?? this.multiLine,
      dotAll: dotAll ?? this.dotAll,
      result: result ?? this.result,
    );
  }
}

class RegexTesterNotifier extends StateNotifier<RegexTesterState> {
  RegexTesterNotifier() : super(const RegexTesterState());

  final _tester = const RegexTester();

  void setPattern(String value) {
    state = state.copyWith(pattern: value);
  }

  void setInput(String value) {
    state = state.copyWith(input: value);
  }

  void setCaseSensitive(bool value) {
    state = state.copyWith(caseSensitive: value);
  }

  void setMultiLine(bool value) {
    state = state.copyWith(multiLine: value);
  }

  void setDotAll(bool value) {
    state = state.copyWith(dotAll: value);
  }

  void run() {
    final result = _tester.test(
      pattern: state.pattern,
      input: state.input,
      caseSensitive: state.caseSensitive,
      multiLine: state.multiLine,
      dotAll: state.dotAll,
    );
    state = state.copyWith(result: result);
  }
}

final regexTesterProvider = StateNotifierProvider<RegexTesterNotifier, RegexTesterState>(
  (ref) => RegexTesterNotifier(),
);
