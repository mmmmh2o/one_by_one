import 'package:flutter/material.dart';

class ToolShellPage extends StatelessWidget {
  final String toolName;

  const ToolShellPage({super.key, required this.toolName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(toolName)),
      body: Center(child: Text('$toolName 功能正在构建中...')),
    );
  }
}
