import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  GUSTUNE — DESIGN SYSTEM
//  Classic & Friendly | Classic Emerald Palette
// ═══════════════════════════════════════════════════════════════════════════

abstract class GusuneColors {
  // ─── Light Mode Palette ─────────────────────────────────────────────────
  static const lightBackground     = Color(0xFFFFFFFF);
  static const lightSurface        = Color(0xFFF5F5F5);  // Card background
  static const lightSurfaceVariant = Color(0xFFEEEEEE);  // Subtle divider/chip
  static const lightPrimary        = Color(0xFF0F7D4B);  // Muted Emerald Green
  static const lightPrimaryVariant = Color(0xFF0A5C37);  // Darker Emerald (pressed)
  static const lightOnPrimary      = Color(0xFFFFFFFF);  // Teks di atas primary
  static const lightText           = Color(0xFF1C1B1F);  // Charcoal (teks utama)
  static const lightTextSecondary  = Color(0xFF6B6B6B);  // Teks abu-abu
  static const lightTextHint       = Color(0xFFAAAAAA);  // Placeholder
  static const lightError          = Color(0xFFBA1A1A);

  // ─── Dark Mode Palette ──────────────────────────────────────────────────
  static const darkBackground      = Color(0xFF121212);  // Dark gray (bukan hitam)
  static const darkSurface         = Color(0xFF1E1E1E);  // Card background
  static const darkSurfaceVariant  = Color(0xFF2A2A2A);  // Elevated surface
  static const darkPrimary         = Color(0xFF1DB954);  // Sage/Emerald terang
  static const darkPrimaryVariant  = Color(0xFF17A349);  // Darker (pressed)
  static const darkOnPrimary       = Color(0xFF000000);  // Teks di atas primary
  static const darkText            = Color(0xFFE6E1E5);  // Teks utama (off-white)
  static const darkTextSecondary   = Color(0xFFAAAAAA);  // Teks sekunder
  static const darkTextHint        = Color(0xFF666666);  // Placeholder
  static const darkError           = Color(0xFFFFB4AB);

  // ─── Neutral (Shared) ───────────────────────────────────────────────────
  static const transparent         = Color(0x00000000);
  static const overlayDark         = Color(0x80000000);  // Overlay semi-transparan
  static const overlayLight        = Color(0x40FFFFFF);

  // ─── Mood Pill Colors ───────────────────────────────────────────────────
  static const moodEnergize        = Color(0xFFFF6B35);  // Oranye semangat
  static const moodFocus           = Color(0xFF4A90D9);  // Biru konsentrasi
  static const moodChill           = Color(0xFF9B59B6);  // Ungu santai
  static const moodOffline         = Color(0xFF7F8C8D);  // Abu-abu netral
}

// ───────────────────────────────────────────────────────────────────────────
//  RADIUS CONSTANTS — Organik & Bersahabat
// ───────────────────────────────────────────────────────────────────────────

abstract class GusuneRadius {
  static const double xs     =  8.0;   // Chip kecil
  static const double sm     = 12.0;   // Card kecil / TextField
  static const double md     = 16.0;   // Card standar
  static const double lg     = 20.0;   // BottomSheet
  static const double xl     = 24.0;   // Card besar / Button utama
  static const double full   = 99.0;   // Pill / Avatar
}

// ───────────────────────────────────────────────────────────────────────────
//  SPACING CONSTANTS
// ───────────────────────────────────────────────────────────────────────────

abstract class GusuneSpacing {
  static const double xs  =  4.0;
  static const double sm  =  8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

// ───────────────────────────────────────────────────────────────────────────
//  TYPOGRAPHY — Nunito (body) + DM Sans (display)
// ───────────────────────────────────────────────────────────────────────────

TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
  return TextTheme(
    // Display — judul besar (Now Playing, nama app)
    displayLarge: GoogleFonts.nunito(
      fontSize: 32, fontWeight: FontWeight.w800, color: primaryText,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: 26, fontWeight: FontWeight.w700, color: primaryText,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 22, fontWeight: FontWeight.w700, color: primaryText,
    ),

    // Headline — section title, nama lagu
    headlineLarge: GoogleFonts.nunito(
      fontSize: 20, fontWeight: FontWeight.w700, color: primaryText,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 18, fontWeight: FontWeight.w600, color: primaryText,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: 16, fontWeight: FontWeight.w600, color: primaryText,
    ),

    // Title — nama artis, label field
    titleLarge: GoogleFonts.nunito(
      fontSize: 16, fontWeight: FontWeight.w600, color: primaryText,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 14, fontWeight: FontWeight.w600, color: primaryText,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 12, fontWeight: FontWeight.w600, color: secondaryText,
    ),

    // Body — konten utama
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16, fontWeight: FontWeight.w400, color: primaryText,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14, fontWeight: FontWeight.w400, color: primaryText,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 12, fontWeight: FontWeight.w400, color: secondaryText,
    ),

    // Label — tombol, chip, badge
    labelLarge: GoogleFonts.nunito(
      fontSize: 14, fontWeight: FontWeight.w700, color: primaryText,
      letterSpacing: 0.2,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: 12, fontWeight: FontWeight.w600, color: primaryText,
    ),
    labelSmall: GoogleFonts.nunito(
      fontSize: 10, fontWeight: FontWeight.w600, color: secondaryText,
      letterSpacing: 0.4,
    ),
  );
}

// ───────────────────────────────────────────────────────────────────────────
//  LIGHT THEME
// ───────────────────────────────────────────────────────────────────────────

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary:          GusuneColors.lightPrimary,
    onPrimary:        GusuneColors.lightOnPrimary,
    primaryContainer: GusuneColors.lightPrimary.withOpacity(0.12),
    onPrimaryContainer: GusuneColors.lightPrimary,
    secondary:        GusuneColors.lightPrimary,
    onSecondary:      GusuneColors.lightOnPrimary,
    secondaryContainer: GusuneColors.lightPrimary.withOpacity(0.08),
    onSecondaryContainer: GusuneColors.lightPrimary,
    surface:          GusuneColors.lightSurface,
    onSurface:        GusuneColors.lightText,
    surfaceContainerHighest: GusuneColors.lightSurfaceVariant,
    onSurfaceVariant: GusuneColors.lightTextSecondary,
    background:       GusuneColors.lightBackground,
    onBackground:     GusuneColors.lightText,
    error:            GusuneColors.lightError,
    onError:          GusuneColors.lightOnPrimary,
    errorContainer:   GusuneColors.lightError.withOpacity(0.12),
    onErrorContainer: GusuneColors.lightError,
    outline:          GusuneColors.lightSurfaceVariant,
    outlineVariant:   GusuneColors.lightSurfaceVariant,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: GusuneColors.lightBackground,
    textTheme: _buildTextTheme(GusuneColors.lightText, GusuneColors.lightTextSecondary),

    // ─── AppBar ───────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: GusuneColors.lightBackground,
      foregroundColor: GusuneColors.lightText,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w800,
        color: GusuneColors.lightText,
      ),
    ),

    // ─── Bottom Navigation Bar ────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: GusuneColors.lightBackground,
      selectedItemColor: GusuneColors.lightPrimary,
      unselectedItemColor: GusuneColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // ─── Card ─────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: GusuneColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.md),
      ),
      margin: EdgeInsets.zero,
    ),

    // ─── FilledButton (Tombol utama) ──────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: GusuneColors.lightPrimary,
        foregroundColor: GusuneColors.lightOnPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GusuneRadius.xl),
        ),
        textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    // ─── OutlinedButton ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: GusuneColors.lightPrimary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: GusuneColors.lightPrimary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GusuneRadius.xl),
        ),
        textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    // ─── TextField / InputDecoration ──────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GusuneColors.lightSurface,
      hintStyle: GoogleFonts.nunito(
        color: GusuneColors.lightTextHint, fontSize: 14,
      ),
      prefixIconColor: GusuneColors.lightTextSecondary,
      suffixIconColor: GusuneColors.lightTextSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: const BorderSide(color: GusuneColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: const BorderSide(color: GusuneColors.lightError, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: GusuneSpacing.md, vertical: GusuneSpacing.md,
      ),
    ),

    // ─── BottomSheet ──────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: GusuneColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(GusuneRadius.lg),
        ),
      ),
      elevation: 8,
    ),

    // ─── Chip (Mood Pills) ────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: GusuneColors.lightSurfaceVariant,
      selectedColor: GusuneColors.lightPrimary.withOpacity(0.15),
      labelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.full),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    // ─── Divider ──────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: GusuneColors.lightSurfaceVariant,
      thickness: 1,
      space: 1,
    ),

    // ─── SnackBar ─────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: GusuneColors.lightText,
      contentTextStyle: GoogleFonts.nunito(color: GusuneColors.lightBackground),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
      ),
    ),
  );
}

// ───────────────────────────────────────────────────────────────────────────
//  DARK THEME
// ───────────────────────────────────────────────────────────────────────────

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary:          GusuneColors.darkPrimary,
    onPrimary:        GusuneColors.darkOnPrimary,
    primaryContainer: GusuneColors.darkPrimary.withOpacity(0.15),
    onPrimaryContainer: GusuneColors.darkPrimary,
    secondary:        GusuneColors.darkPrimary,
    onSecondary:      GusuneColors.darkOnPrimary,
    secondaryContainer: GusuneColors.darkPrimary.withOpacity(0.10),
    onSecondaryContainer: GusuneColors.darkPrimary,
    surface:          GusuneColors.darkSurface,
    onSurface:        GusuneColors.darkText,
    surfaceContainerHighest: GusuneColors.darkSurfaceVariant,
    onSurfaceVariant: GusuneColors.darkTextSecondary,
    background:       GusuneColors.darkBackground,
    onBackground:     GusuneColors.darkText,
    error:            GusuneColors.darkError,
    onError:          GusuneColors.darkBackground,
    errorContainer:   GusuneColors.darkError.withOpacity(0.15),
    onErrorContainer: GusuneColors.darkError,
    outline:          GusuneColors.darkSurfaceVariant,
    outlineVariant:   GusuneColors.darkSurfaceVariant,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: GusuneColors.darkBackground,
    textTheme: _buildTextTheme(GusuneColors.darkText, GusuneColors.darkTextSecondary),

    // ─── AppBar ───────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: GusuneColors.darkBackground,
      foregroundColor: GusuneColors.darkText,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w800,
        color: GusuneColors.darkText,
      ),
    ),

    // ─── Bottom Navigation Bar ────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: GusuneColors.darkSurface,
      selectedItemColor: GusuneColors.darkPrimary,
      unselectedItemColor: GusuneColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // ─── Card ─────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: GusuneColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.md),
      ),
      margin: EdgeInsets.zero,
    ),

    // ─── FilledButton ─────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: GusuneColors.darkPrimary,
        foregroundColor: GusuneColors.darkOnPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GusuneRadius.xl),
        ),
        textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    // ─── OutlinedButton ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: GusuneColors.darkPrimary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: GusuneColors.darkPrimary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GusuneRadius.xl),
        ),
        textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    // ─── TextField ────────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GusuneColors.darkSurfaceVariant,
      hintStyle: GoogleFonts.nunito(
        color: GusuneColors.darkTextHint, fontSize: 14,
      ),
      prefixIconColor: GusuneColors.darkTextSecondary,
      suffixIconColor: GusuneColors.darkTextSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: const BorderSide(color: GusuneColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
        borderSide: const BorderSide(color: GusuneColors.darkError, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: GusuneSpacing.md, vertical: GusuneSpacing.md,
      ),
    ),

    // ─── BottomSheet ──────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: GusuneColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(GusuneRadius.lg),
        ),
      ),
      elevation: 8,
    ),

    // ─── Chip ─────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: GusuneColors.darkSurfaceVariant,
      selectedColor: GusuneColors.darkPrimary.withOpacity(0.20),
      labelStyle: GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w600,
        color: GusuneColors.darkText,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.full),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    // ─── Divider ──────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: GusuneColors.darkSurfaceVariant,
      thickness: 1,
      space: 1,
    ),

    // ─── SnackBar ─────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: GusuneColors.darkSurfaceVariant,
      contentTextStyle: GoogleFonts.nunito(color: GusuneColors.darkText),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GusuneRadius.sm),
      ),
    ),
  );
}

// ───────────────────────────────────────────────────────────────────────────
//  GUSTUNE THEME — Entry Point
// ───────────────────────────────────────────────────────────────────────────

/// Kelas utama untuk mengakses theme Gustune.
/// Contoh penggunaan:
///   MaterialApp(
///     theme: GusuneTheme.light,
///     darkTheme: GusuneTheme.dark,
///     themeMode: ThemeMode.system,
///   )
abstract class GusuneTheme {
  static ThemeData get light => buildLightTheme();
  static ThemeData get dark  => buildDarkTheme();
}
