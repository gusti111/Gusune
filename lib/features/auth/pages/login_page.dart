import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/services/secure_storage.dart';
import '../../navigation/pages/main_navigation.dart';
import '../widgets/custom_text_field.dart';
import 'registrasi_page.dart';
import 'forgot_password_page.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  LOGIN PAGE
//  Stateful + Riverpod. Menggunakan pushReplacement agar stack login
//  dihancurkan setelah masuk — tombol back tidak bisa menembus kembali.
// ═══════════════════════════════════════════════════════════════════════════

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ─── LOGIKA LOGIN ────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    // Tutup keyboard
    FocusScope.of(context).unfocus();

    // Validasi semua field
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      // ── Simulasi request ke server (ganti dengan API call nyata) ────────
      await Future.delayed(const Duration(milliseconds: 1200));

      // ── Simulasi token yang diterima dari server ──────────────────────
      const mockToken = 'gustune_session_token_mock_v1';

      // ── Simpan sesi ke secure storage ─────────────────────────────────
      final storageService = ref.read(secureStorageServiceProvider);
      await storageService.saveSession(
        token: mockToken,
        username: _emailCtrl.text.split('@').first, // Ambil bagian sebelum @
        email: _emailCtrl.text.trim(),
        nimOrPhone: '',
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      // ── Navigasi ke Home — stack login dihancurkan (pushReplacement) ──
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
      _showErrorSnackBar('Login gagal. Periksa koneksi internet kamu.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: GusuneSpacing.lg,
            vertical: GusuneSpacing.xl,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 120),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────────────────
                  _buildHeader(theme, colors),

                  const SizedBox(height: GusuneSpacing.xxl),

                  // ── Form ───────────────────────────────────────────────
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GusuneTextField(
                          label: 'Email',
                          hint: 'contoh@email.com',
                          controller: _emailCtrl,
                          validator: Validators.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 20,
                          ),
                          onSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocus),
                        ),

                        const SizedBox(height: GusuneSpacing.md),

                        GusuneTextField(
                          label: 'Password',
                          hint: 'Masukkan password',
                          controller: _passwordCtrl,
                          validator: Validators.password,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus,
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          onSubmitted: (_) => _handleLogin(),
                        ),

                        const SizedBox(height: GusuneSpacing.sm),

                        // ── Remember Me + Forgot Password ────────────────
                        _buildRememberRow(theme, colors),
                      ],
                    ),
                  ),

                  const SizedBox(height: GusuneSpacing.lg),

                  // ── Tombol Login ────────────────────────────────────────
                  _buildLoginButton(colors),

                  const SizedBox(height: GusuneSpacing.lg),

                  // ── Divider ─────────────────────────────────────────────
                  _buildDivider(theme, colors),

                  const SizedBox(height: GusuneSpacing.lg),

                  // ── Link ke Register ────────────────────────────────────
                  _buildRegisterLink(theme, colors),

                  const Spacer(),

                  // ── Footer ──────────────────────────────────────────────
                  _buildFooter(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── WIDGET BUILDERS ─────────────────────────────────────────────────────

  Widget _buildHeader(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo / Icon App
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(GusuneRadius.md),
          ),
          child: Icon(
            Icons.music_note_rounded,
            color: colors.onPrimary,
            size: 32,
          ),
        ),

        const SizedBox(height: GusuneSpacing.lg),

        Text('Selamat datang', style: theme.textTheme.displaySmall),
        const SizedBox(height: GusuneSpacing.xs),
        Text(
          'Masuk ke akun Gustune kamu.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberRow(ThemeData theme, ColorScheme colors) {
    return Row(
      children: [
        // Remember Me
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (v) => setState(() => _rememberMe = v ?? false),
            activeColor: colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Text('Tetap masuk sesi', style: theme.textTheme.bodyMedium),
        ),

        const Spacer(),

        // Forgot Password
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
          ),
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            'Lupa password?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ColorScheme colors) {
    return FilledButton(
      onPressed: _isLoading ? null : _handleLogin,
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.onPrimary,
              ),
            )
          : const Text('Masuk'),
    );
  }

  Widget _buildDivider(ThemeData theme, ColorScheme colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GusuneSpacing.md),
          child: Text(
            'atau',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant)),
      ],
    );
  }

  Widget _buildRegisterLink(ThemeData theme, ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrasiPage()),
          ),
          child: Text(
            'Daftar sekarang',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Center(
      child: Text(
        'Gustune v1.0 · Classic & Friendly',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
