import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  MOOD PILL LIST
//  Filter chip horizontal di bagian atas Home.
//  Memilih mood akan mengubah konten seluruh halaman secara instan.
// ═══════════════════════════════════════════════════════════════════════════

// ─── Model ────────────────────────────────────────────────────────────────

enum MoodFilter { energize, focus, chill, offline }

extension MoodFilterX on MoodFilter {
  String get label {
    switch (this) {
      case MoodFilter.energize:
        return '⚡ Energize';
      case MoodFilter.focus:
        return '🎯 Focus';
      case MoodFilter.chill:
        return '🌊 Chill';
      case MoodFilter.offline:
        return '📴 Offline';
    }
  }

  Color get accentColor {
    switch (this) {
      case MoodFilter.energize:
        return GusuneColors.moodEnergize;
      case MoodFilter.focus:
        return GusuneColors.moodFocus;
      case MoodFilter.chill:
        return GusuneColors.moodChill;
      case MoodFilter.offline:
        return GusuneColors.moodOffline;
    }
  }

  String get description {
    switch (this) {
      case MoodFilter.energize:
        return 'Musik untuk semangat & olahraga';
      case MoodFilter.focus:
        return 'Musik tanpa lirik untuk konsentrasi';
      case MoodFilter.chill:
        return 'Santai dan rileks';
      case MoodFilter.offline:
        return 'Hanya lagu yang sudah diunduh';
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────

/// Provider mood aktif. null = semua konten ditampilkan (default).
final activeMoodProvider = StateProvider<MoodFilter?>((ref) => null);

// ─── Widget ───────────────────────────────────────────────────────────────

class MoodPillList extends ConsumerWidget {
  const MoodPillList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMood = ref.watch(activeMoodProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: GusuneSpacing.md),
        itemCount: MoodFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: GusuneSpacing.sm),
        itemBuilder: (context, index) {
          final mood = MoodFilter.values[index];
          final isActive = activeMood == mood;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: FilterChip(
              label: Text(
                mood.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isActive ? Colors.white : colors.onSurface,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              selected: isActive,
              onSelected: (_) {
                // Toggle: tap mood aktif → reset ke null (semua konten)
                ref.read(activeMoodProvider.notifier).state = isActive
                    ? null
                    : mood;
              },
              backgroundColor: colors.surfaceContainerHighest,
              selectedColor: mood.accentColor,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(
                horizontal: GusuneSpacing.sm,
                vertical: 0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GusuneRadius.full),
              ),
            ),
          );
        },
      ),
    );
  }
}
