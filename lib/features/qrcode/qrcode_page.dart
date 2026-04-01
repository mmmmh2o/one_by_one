import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'logic/qrcode_logic.dart';
import 'providers.dart';

class QrcodePage extends ConsumerStatefulWidget {
  const QrcodePage({super.key});

  @override
  ConsumerState<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends ConsumerState<QrcodePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrcodeProvider);
    final notifier = ref.read(qrcodeProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'qrcode',
      scrollable: true,
      children: [
        // 模式切换
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: '生成',
                  icon: Icons.qr_code_2,
                  selected: state.mode == QrMode.generate,
                  onTap: () => notifier.setMode(QrMode.generate),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ModeChip(
                  label: '扫描',
                  icon: Icons.qr_code_scanner,
                  selected: state.mode == QrMode.scan,
                  onTap: () => notifier.setMode(QrMode.scan),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 内容区
        if (state.mode == QrMode.generate) ...[
          AppCard(
            child: AppInput(
              label: '输入内容',
              controller: _controller,
              hint: '输入文本或链接',
              onChanged: notifier.setInputText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('尺寸', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: QrSize.values.map((size) {
                    final label = switch (size) {
                      QrSize.small => '小',
                      QrSize.medium => '中',
                      QrSize.large => '大',
                    };
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: state.qrSize == size,
                        onSelected: (_) => notifier.setQrSize(size),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (notifier.canGenerate)
            Center(
              child: AppCard(
                child: Column(
                  children: [
                    QrImageView(
                      data: state.inputText,
                      version: QrVersions.auto,
                      size: notifier.qrPixelSize,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '长按保存到相册',
                      style: scaledTextStyle(
                          Theme.of(context).textTheme.bodySmall,
                          ui.textScaleFactor),
                    ),
                  ],
                ),
              ),
            )
          else
            Center(
              child: Text(
                '输入内容后生成二维码',
                style: scaledTextStyle(
                    Theme.of(context).textTheme.bodyMedium,
                    ui.textScaleFactor),
              ),
            ),
        ] else ...[
          // 扫描模式
          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: MobileScanner(
                onDetect: (capture) {
                  final barcode = capture.barcodes.firstOrNull;
                  if (barcode?.rawValue != null) {
                    notifier.setScannedResult(barcode!.rawValue!);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.scannedResult != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('扫描结果',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  SelectableText(
                    state.scannedResult!,
                    style: scaledTextStyle(
                        Theme.of(context).textTheme.bodyLarge,
                        ui.textScaleFactor),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: '复制结果',
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: state.scannedResult!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已复制到剪贴板')),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            Center(
              child: Text(
                '将二维码放入扫描框内',
                style: scaledTextStyle(
                    Theme.of(context).textTheme.bodyMedium,
                    ui.textScaleFactor),
              ),
            ),
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: selected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Text(label,
                style: TextStyle(
                    color: selected
                        ? scheme.onPrimaryContainer
                        : scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
