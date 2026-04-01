import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:toolbox/features/common/tool_scaffold.dart';

/// 网速测试页面（WebView 加载本地 HTML 测速前端）
class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({super.key});

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      );
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final html = await rootBundle.loadString('assets/speedtest.html');
    await _controller.loadHtmlString(html, baseUrl: 'https://www.baidu.com');
  }

  @override
  Widget build(BuildContext context) {
    return ToolScaffold(
      toolId: 'speed_test',
      expandBody: true,
      children: [
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_loading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}
