import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'core/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 禁止运行时联网下载字体，避免启动阻塞
  GoogleFonts.config.allowRuntimeFetching = false;

  final container = ProviderContainer();

  // 先展示首帧，后台异步加载用户配置
  final hydrationFuture = container.read(settingsProvider.notifier).waitForHydration();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );

  // 首帧渲染后再等待配置完成，不再阻塞启动
  await hydrationFuture;
}
