import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolbox/app/app_router.dart';
import 'package:toolbox/app/app_theme.dart';
import 'package:toolbox/core/providers/router_provider.dart';
import 'package:toolbox/core/providers/settings_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: '工具箱',
      theme: AppTheme.light(settings),
      darkTheme: AppTheme.dark(settings),
      themeMode: settings.themeMode,
      locale: settings.locale,
      routerConfig: router,
    );
  }
}
