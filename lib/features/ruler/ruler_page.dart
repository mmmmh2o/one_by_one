import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class RulerPage extends ConsumerStatefulWidget {
  const RulerPage({super.key});

  @override
  ConsumerState<RulerPage> createState() => _RulerPageState();
}

class _RulerPageState extends ConsumerState<RulerPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final length = ref.read(rulerProvider).lengthCm;
    _controller = TextEditingController(text: length.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLengthChanged(double value) {
    ref.read(rulerProvider.notifier).updateLength(value);
    _controller.text = value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rulerProvider);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('尺子')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInput(
                    label: '长度（cm）',
                    controller: _controller,
                    hint: '输入数值',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        ref.read(rulerProvider.notifier).updateLength(parsed);
                      }
                    },
                    suffix: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _onLengthChanged(10.0),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '英寸：${state.measurement.valueInInch.toStringAsFixed(2)}',
                    style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Slider(
              min: 0,
              max: 50,
              value: state.lengthCm.clamp(0, 50),
              onChanged: _onLengthChanged,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '当前：${state.lengthCm.toStringAsFixed(1)} cm',
              style: scaledTextStyle(Theme.of(context).textTheme.bodySmall, ui.textScaleFactor),
            ),
          ],
        ),
      ),
    );
  }
}
