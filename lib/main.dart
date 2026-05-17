import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/theme/app_theme.dart';
import 'core/database/isar_service.dart';
import 'core/database/repositories/track_repository.dart';
import 'features/auth/pages/login_page.dart';
import 'features/navigation/pages/main_navigation.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  GUSTUNE — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── 1. Kunci orientasi ke Portrait ───────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ─── 2. Transparansi status bar ───────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ─── 3. Inisialisasi Database Isar ────────────────────────────────────
  // Wajib sebelum runApp agar IsarService.instance tersedia untuk Provider.
  await IsarService.initialize();

  // ─── 4. Inisialisasi data default (Liked Songs playlist) ──────────────
  final repo = TrackRepository(IsarService.instance);
  await repo.ensureDefaultPlaylistExists();

  // ─── 5. Auth Check — Baca token dari secure storage ───────────────────
  // Cek apakah sesi login sebelumnya masih tersimpan.
  const secureStorage = FlutterSecureStorage();
  final sessionToken = await secureStorage.read(key: 'session_token');
  final isLoggedIn = sessionToken != null && sessionToken.isNotEmpty;

  // ─── 6. Jalankan App ──────────────────────────────────────────────────
  runApp(ProviderScope(child: GusuneApp(isLoggedIn: isLoggedIn)));
}

class GusuneApp extends ConsumerWidget {
  /// Flag hasil auth-check dari secure storage.
  /// true  → langsung ke MainNavigation (skip login screen)
  /// false → ke LoginPage
  final bool isLoggedIn;

  const GusuneApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gustune',
      debugShowCheckedModeBanner: false,

      // ─── Theme System ──────────────────────────────────────────────────
      theme: GusuneTheme.light,
      darkTheme: GusuneTheme.dark,
      themeMode: ThemeMode.system,

      // ─── Entry Route (Auth Gate — Tanpa TODO) ─────────────────────────
      // Rute ditentukan berdasarkan hasil auth-check di main() atas.
      // Tidak ada lagi "tombol back menembus ke login" karena:
      // - Jika isLoggedIn → pushReplacement sudah terjadi di level ini
      // - Jika tidak      → LoginPage menggunakan pushReplacement saat sukses
      home: isLoggedIn ? const MainNavigation() : const LoginPage(),

      // ─── Global Builder ───────────────────────────────────────────────
      builder: (context, child) {
        return MediaQuery(
          // Mencegah teks sistem membesar dan merusak layout
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
