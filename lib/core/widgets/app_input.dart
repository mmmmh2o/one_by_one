import 'package:flutter/material.dart';

import '../constants/spacing.dart';

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffix;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const AppInput({
    super.key,
    required this.label,
    required this.controller,
    this.suffix,
    this.hint,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffix,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
