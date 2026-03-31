import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';

enum ToolPageStatus { loading, ready, empty, error }

class ToolPageTemplate extends ConsumerWidget {
  final String title;
  final ToolPageStatus status;
  final Widget child;
  final String? message;
  final VoidCallback? onRetry;

  const ToolPageTemplate({
    super.key,
    required this.title,
    this.status = ToolPageStatus.ready,
    required this.child,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    Widget body;
    switch (status) {
      case ToolPageStatus.loading:
        body = const Center(child: LoadingIndicator());
        break;
      case ToolPageStatus.empty:
        body = EmptyState(message: message ?? '暂无内容');
        break;
      case ToolPageStatus.error:
        body = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message ?? '发生错误', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            if (onRetry != null) AppButton(label: '重试', onPressed: onRetry!),
          ],
        );
        break;
      case ToolPageStatus.ready:
      default:
        body = child;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: settings.enableAnimations ? 400 : 0),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
