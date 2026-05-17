import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  CUSTOM TEXT FIELD
//  Widget form field standar Gustune yang sudah di-styling sesuai design system.
//  Digunakan di semua halaman Auth agar konsisten dan tidak mengulang kode.
// ═══════════════════════════════════════════════════════════════════════════

class GusuneTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword; // Aktifkan toggle show/hide password
  final Widget? prefixIcon;
  final Widget? suffixIcon; // Override suffix (diabaikan jika isPassword)
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool autofocus;

  const GusuneTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<GusuneTextField> createState() => _GusuneTextFieldState();
}

class _GusuneTextFieldState extends State<GusuneTextField> {
  bool _obscureText = true; // Hanya relevan jika isPassword = true

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Label ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: GusuneSpacing.xs),
          child: Text(
            widget.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onSurface,
            ),
          ),
        ),

        // ─── Field ──────────────────────────────────────────────────────
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(colors),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colors) {
    // Jika isPassword → tampilkan toggle show/hide
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: colors.onSurfaceVariant,
          size: 20,
        ),
        tooltip: _obscureText ? 'Tampilkan password' : 'Sembunyikan password',
      );
    }
    // Jika ada suffix icon custom → tampilkan
    return widget.suffixIcon;
  }
}
