import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class DateCalculatorPage extends ConsumerWidget {
  const DateCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dateCalculatorProvider);
    final notifier = ref.read(dateCalculatorProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('日期计算')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DatePickerRow(
                    label: '开始日期',
                    value: state.from,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: state.from,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) notifier.setFrom(picked);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DatePickerRow(
                    label: '结束日期',
                    value: state.to,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: state.to,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) notifier.setTo(picked);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '计算差值', onPressed: notifier.calculate),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: state.result == null
                  ? Text(
                      '选择日期后点击计算',
                      style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '总天数：${state.result!.days} 天',
                          style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '约 ${state.result!.weeks} 周 ${state.result!.remainingDays} 天',
                          style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;

  const _DatePickerRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$label：${_fmt(value)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}
