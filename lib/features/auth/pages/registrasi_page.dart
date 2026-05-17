import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/services/secure_storage.dart';
import '../../navigation/pages/main_navigation.dart';
import '../widgets/custom_text_field.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  REGISTRASI PAGE
//  Formulir pendaftaran pengguna baru dengan validasi RegExp berlapis.
// ═══════════════════════════════════════════════════════════════════════════

class RegistrasiPage extends ConsumerStatefulWidget {
  const RegistrasiPage({super.key});

  @override
  ConsumerState<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends ConsumerState<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nimPhoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _nimPhoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _rememberMe = true; // Default true untuk kenyamanan pengguna baru
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _nimPhoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _nimPhoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // ─── LOGIKA REGISTRASI ───────────────────────────────────────────────────

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      // Simulasi request ke server
      await Future.delayed(const Duration(milliseconds: 1500));

      const mockToken = 'gustune_session_token_new_user_v1';

      final storageService = ref.read(secureStorageServiceProvider);
      await storageService.saveSession(
        token: mockToken,
        username: _usernameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        nimOrPhone: _nimPhoneCtrl.text.trim(),
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      // Langsung ke Home setelah daftar — tidak perlu login lagi
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const MainNavigation(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi gagal. Coba lagi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────

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
        title: const Text('Buat Akun'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: GusuneSpacing.lg,
            vertical: GusuneSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Subjudul ────────────────────────────────────────────
                Text(
                  'Isi data di bawah untuk\nmulai mendengarkan musik.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: GusuneSpacing.xl),

                // ── Username ─────────────────────────────────────────────
                GusuneTextField(
                  label: 'Username',
                  hint: 'contoh: budi_pratama',
                  controller: _usernameCtrl,
                  validator: Validators.username,
                  focusNode: _usernameFocus,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  // Paksa lowercase dan tanpa spasi via formatter
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                ),

                const SizedBox(height: GusuneSpacing.md),

                // ── Email ─────────────────────────────────────────────────
                GusuneTextField(
                  label: 'Email',
                  hint: 'contoh@email.com',
                  controller: _emailCtrl,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_nimPhoneFocus),
                ),

                const SizedBox(height: GusuneSpacing.md),

                // ── NIM / No. HP ──────────────────────────────────────────
                GusuneTextField(
                  label: 'NIM / No. HP',
                  hint: 'Hanya angka',
                  controller: _nimPhoneCtrl,
                  validator: Validators.nimOrPhone,
                  keyboardType: TextInputType.number,
                  focusNode: _nimPhoneFocus,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),

                const SizedBox(height: GusuneSpacing.md),

                // ── Password ──────────────────────────────────────────────
                GusuneTextField(
                  label: 'Password',
                  hint: 'Min. 8 karakter, kapital & angka',
                  controller: _passwordCtrl,
                  validator: Validators.password,
                  isPassword: true,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmPassFocus),
                ),

                const SizedBox(height: GusuneSpacing.md),

                // ── Konfirmasi Password ───────────────────────────────────
                GusuneTextField(
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password di atas',
                  controller: _confirmPassCtrl,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordCtrl.text),
                  isPassword: true,
                  focusNode: _confirmPassFocus,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  onSubmitted: (_) => _handleRegister(),
                ),

                const SizedBox(height: GusuneSpacing.md),

                // ── Remember Me ───────────────────────────────────────────
                _buildRememberMe(theme, colors),

                const SizedBox(height: GusuneSpacing.xl),

                // ── Tombol Daftar ─────────────────────────────────────────
                FilledButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onPrimary,
                          ),
                        )
                      : const Text('Buat Akun'),
                ),

                const SizedBox(height: GusuneSpacing.lg),

                // ── Password Requirements Info ─────────────────────────────
                _buildPasswordHints(theme, colors),

                const SizedBox(height: GusuneSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── WIDGET BUILDERS ─────────────────────────────────────────────────────

  Widget _buildRememberMe(ThemeData theme, ColorScheme colors) {
    return CheckboxListTile(
      value: _rememberMe,
      onChanged: (v) => setState(() => _rememberMe = v ?? true),
      activeColor: colors.primary,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.xs),
      ),
      title: Text('Tetap masuk sesi', style: theme.textTheme.bodyMedium),
      subtitle: Text(
        'Kamu tidak perlu login ulang setiap membuka app',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildPasswordHints(ThemeData theme, ColorScheme colors) {
    final requirements = [
      'Minimal 8 karakter',
      'Mengandung huruf kapital (A-Z)',
      'Mengandung huruf kecil (a-z)',
      'Mengandung angka (0-9)',
    ];

    return Container(
      padding: const EdgeInsets.all(GusuneSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Syarat Password',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: GusuneSpacing.xs),
          ...requirements.map(
            (req) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: colors.onPrimaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    req,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
