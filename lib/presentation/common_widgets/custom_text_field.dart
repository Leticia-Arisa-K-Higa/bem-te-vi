// lib/presentation/common_widgets/custom_text_field.dart

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLines; // <--- ADICIONE ESTA PROPRIEDADE

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1, // <--- E INICIALIZE COM UM VALOR PADRÃO (geralmente 1)
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController? effectiveController =
        controller ??
        (initialValue != null
            ? TextEditingController(text: initialValue)
            : null);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: effectiveController,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLines: maxLines, // <--- PASSE A PROPRIEDADE AQUI
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
