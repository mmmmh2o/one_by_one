import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/code_formatter.dart';

class CodeFormatterState {
  final String input;
  final String output;
  final CodeFormatType formatType;
  final int indentSize;

  const CodeFormatterState({
    this.input = '',
    this.output = '',
    this.formatType = CodeFormatType.json,
    this.indentSize = 2,
  });

  CodeFormatterState copyWith({
    String? input,
    String? output,
    CodeFormatType? formatType,
    int? indentSize,
  }) {
    return CodeFormatterState(
      input: input ?? this.input,
      output: output ?? this.output,
      formatType: formatType ?? this.formatType,
      indentSize: indentSize ?? this.indentSize,
    );
  }
}

class CodeFormatterNotifier extends StateNotifier<CodeFormatterState> {
  CodeFormatterNotifier() : super(const CodeFormatterState());

  final _engine = const CodeFormatterEngine();

  void setInput(String value) => state = state.copyWith(input: value);

  void setFormatType(CodeFormatType type) => state = state.copyWith(formatType: type);

  void setIndentSize(int size) => state = state.copyWith(indentSize: size);

  void format() {
    final result = _engine.format(
      state.input,
      state.formatType,
      indentSize: state.indentSize,
    );
    state = state.copyWith(output: result);
  }

  void compress() {
    final result = _engine.compress(state.input, state.formatType);
    state = state.copyWith(output: result);
  }

  void loadExample() {
    final example = switch (state.formatType) {
      CodeFormatType.json => '{"name":"工具箱","version":"0.1.0","features":["格式化","压缩"],"config":{"theme":"dark","lang":"zh"}}',
      CodeFormatType.html => '<html><head><title>Toolbox</title></head><body><div class="app"><h1>Hello</h1><p>Welcome to Toolbox!</p></div></body></html>',
      CodeFormatType.css => '.app{display:flex;flex-direction:column;align-items:center;padding:16px;background:#fff}.title{font-size:24px;color:#333;margin-bottom:8px}',
      CodeFormatType.javascript => 'function greet(name){const msg=`Hello, ${name}!`;console.log(msg);return msg}const items=[1,2,3,4,5];const sum=items.reduce((a,b)=>a+b,0);',
    };
    state = state.copyWith(input: example);
  }
}

final codeFormatterProvider =
    StateNotifierProvider<CodeFormatterNotifier, CodeFormatterState>(
  (ref) => CodeFormatterNotifier(),
);
