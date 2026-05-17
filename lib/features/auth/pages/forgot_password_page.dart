import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';
import '../widgets/custom_text_field.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  FORGOT PASSWORD PAGE — Stateless Widget Taktis
//  Mengeksekusi Navigator.pop setelah permintaan pemulihan (simulasi) dikirim.
// ═══════════════════════════════════════════════════════════════════════════

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false; // Tampilkan UI konfirmasi setelah terkirim

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulasi
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSent = true;
    });

    // Kembali ke Login setelah 2 detik (Navigator.pop)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lupa Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GusuneSpacing.lg),
          child: _isSent
              ? _buildSuccessState(theme, colors)
              : _buildFormState(theme, colors),
        ),
      ),
    );
  }

  // ─── State: Form ─────────────────────────────────────────────────────────

  Widget _buildFormState(ThemeData theme, ColorScheme colors) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(GusuneRadius.md),
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              color: colors.onPrimaryContainer,
              size: 30,
            ),
          ),

          const SizedBox(height: GusuneSpacing.lg),

          Text('Pulihkan Password', style: theme.textTheme.headlineMedium),
          const SizedBox(height: GusuneSpacing.xs),
          Text(
            'Masukkan email yang terdaftar. Kami akan kirimkan tautan untuk reset password.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: GusuneSpacing.xl),

          GusuneTextField(
            label: 'Email Terdaftar',
            hint: 'contoh@email.com',
            controller: _emailCtrl,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            onSubmitted: (_) => _handleSend(),
          ),

          const SizedBox(height: GusuneSpacing.xl),

          FilledButton(
            onPressed: _isLoading ? null : _handleSend,
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.onPrimary,
                    ),
                  )
                : const Text('Kirim Tautan Pemulihan'),
          ),
        ],
      ),
    );
  }

  // ─── State: Sukses ────────────────────────────────────────────────────────

  Widget _buildSuccessState(ThemeData theme, ColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              color: colors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: GusuneSpacing.lg),
          Text('Email Terkirim!', style: theme.textTheme.headlineMedium),
          const SizedBox(height: GusuneSpacing.sm),
          Text(
            'Cek inbox ${_emailCtrl.text.trim()}.\nTautan pemulihan sudah dikirim.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: GusuneSpacing.lg),
          LinearProgressIndicator(
            color: colors.primary,
            backgroundColor: colors.primaryContainer,
          ),
          const SizedBox(height: GusuneSpacing.sm),
          Text(
            'Kembali ke halaman login...',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
