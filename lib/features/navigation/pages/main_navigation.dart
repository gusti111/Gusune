import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../home/pages/home_page.dart';
import '../../../../../search/pages/search_page.dart';
import '../../../../../library/pages/library_page.dart';
import '../../../../../profile/pages/profile_page.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  MAIN NAVIGATION
//  Pengontrol BottomNavigationBar utama.
//  Menggunakan IndexedStack agar semua halaman tetap hidup di memori
//  (tidak di-rebuild setiap kali tab diganti — preserves scroll position).
// ═══════════════════════════════════════════════════════════════════════════

/// Provider untuk index tab aktif.
/// Diakses dari mana saja untuk berpindah tab secara programatis.
/// Contoh: setelah download selesai, loncat ke Library tab.
final activeTabIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  // Daftar halaman — urutan harus sama dengan item BottomNavigationBar
  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(activeTabIndexProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // ─── Konten Halaman ─────────────────────────────────────────────────
      // IndexedStack menjaga state semua halaman tetap aktif di memori.
      // Ini mencegah scroll position reset dan re-fetch data saat ganti tab.
      body: IndexedStack(index: activeIndex, children: _pages),

      // ─── Bottom Navigation Bar ───────────────────────────────────────────
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mini Player — muncul di atas BottomBar saat lagu aktif ──────
          // TODO (Fase Player): Ganti dengan MiniPlayer widget aktual
          // yang di-watch dari playerStateProvider
          const _MiniPlayerPlaceholder(),

          // ── Navigation Bar ───────────────────────────────────────────────
          NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: (index) {
              ref.read(activeTabIndexProvider.notifier).state = index;
            },
            backgroundColor: colors.surface,
            indicatorColor: colors.primaryContainer,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Cari',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music_rounded),
                label: 'Koleksi',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  MINI PLAYER PLACEHOLDER
//  Akan diganti dengan mini_player.dart di Fase Player.
//  Saat ini hanya tampil jika ada lagu aktif (simulasi: tidak tampil).
// ═══════════════════════════════════════════════════════════════════════════

class _MiniPlayerPlaceholder extends ConsumerWidget {
  const _MiniPlayerPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Saat Fase Player selesai, ganti kondisi ini dengan:
    // final playerState = ref.watch(playerStateProvider);
    // if (playerState.currentTrack == null) return const SizedBox.shrink();
    const bool hasActiveTrack = false; // Placeholder

    if (!hasActiveTrack) return const SizedBox.shrink();

    // Skeleton mini player — tidak akan pernah dicapai sampai Fase Player
    return Container(
      height: 64,
      color: Theme.of(context).colorScheme.surface,
      child: const Center(child: Text('Mini Player')),
    );
  }
}
