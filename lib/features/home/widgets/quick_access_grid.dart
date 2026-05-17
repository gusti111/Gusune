import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  QUICK ACCESS GRID
//  Grid 2x3 berisi riwayat playlist/track terakhir yang diputar.
//  Modifikasi dari pola "Recent" di Spotify.
// ═══════════════════════════════════════════════════════════════════════════

// ─── Model ────────────────────────────────────────────────────────────────

class QuickAccessItem {
  final String id;
  final String title;
  final String? thumbnailUrl;
  final Color fallbackColor;
  final IconData fallbackIcon;
  final bool isPlaylist;

  const QuickAccessItem({
    required this.id,
    required this.title,
    required this.fallbackColor,
    required this.fallbackIcon,
    this.thumbnailUrl,
    this.isPlaylist = false,
  });
}

// ─── Mock Data Provider ────────────────────────────────────────────────────
// Fase ini menggunakan data statis.
// Pada Fase Player, ini akan diganti dengan data dari:
// - Isar database (riwayat offline)
// - SharedPreferences (riwayat YT stream terakhir)

final quickAccessItemsProvider = Provider<List<QuickAccessItem>>((ref) {
  return [
    QuickAccessItem(
      id: 'liked',
      title: 'Liked Songs',
      fallbackColor: GusuneColors.lightPrimary,
      fallbackIcon: Icons.favorite_rounded,
      isPlaylist: true,
    ),
    QuickAccessItem(
      id: 'downloaded',
      title: 'Unduhan',
      fallbackColor: GusuneColors.moodFocus,
      fallbackIcon: Icons.download_done_rounded,
      isPlaylist: true,
    ),
    QuickAccessItem(
      id: 'recent1',
      title: 'Terakhir Diputar',
      fallbackColor: GusuneColors.moodEnergize,
      fallbackIcon: Icons.history_rounded,
      isPlaylist: false,
    ),
    QuickAccessItem(
      id: 'recent2',
      title: 'Fokus Koding',
      fallbackColor: GusuneColors.moodChill,
      fallbackIcon: Icons.headphones_rounded,
      isPlaylist: true,
    ),
    QuickAccessItem(
      id: 'recent3',
      title: 'Lari Pagi',
      fallbackColor: GusuneColors.moodEnergize,
      fallbackIcon: Icons.directions_run_rounded,
      isPlaylist: true,
    ),
    QuickAccessItem(
      id: 'recent4',
      title: 'Santai Malam',
      fallbackColor: GusuneColors.moodOffline,
      fallbackIcon: Icons.nights_stay_rounded,
      isPlaylist: true,
    ),
  ];
});

// ─── Widget ───────────────────────────────────────────────────────────────

class QuickAccessGrid extends ConsumerWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(quickAccessItemsProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: GusuneSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: GusuneSpacing.sm,
        crossAxisSpacing: GusuneSpacing.sm,
        childAspectRatio: 3.4, // Lebar vs tinggi — card landscape pendek
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _QuickAccessCard(item: items[index], theme: theme, colors: colors),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────

class _QuickAccessCard extends StatelessWidget {
  final QuickAccessItem item;
  final ThemeData theme;
  final ColorScheme colors;

  const _QuickAccessCard({
    required this.item,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(GusuneRadius.xs),
      child: InkWell(
        onTap: () {
          // TODO (Fase Player): Buka playlist atau langsung play track
        },
        borderRadius: BorderRadius.circular(GusuneRadius.xs),
        child: Row(
          children: [
            // ── Thumbnail / Icon ────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(GusuneRadius.xs),
                bottomLeft: Radius.circular(GusuneRadius.xs),
              ),
              child: Container(
                width: 52,
                height: double.infinity,
                color: item.fallbackColor,
                child: item.thumbnailUrl != null
                    ? Image.network(
                        item.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackIcon(),
                      )
                    : _buildFallbackIcon(),
              ),
            ),

            // ── Title ───────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GusuneSpacing.sm,
                ),
                child: Text(
                  item.title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(item.fallbackIcon, color: Colors.white, size: 22),
    );
  }
}
