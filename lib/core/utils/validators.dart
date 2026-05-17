// ═══════════════════════════════════════════════════════════════════════════
//  GUSTUNE — VALIDATORS
//  Semua logika validasi form dipusatkan di sini.
//  Widget TIDAK boleh mendefinisikan RegExp sendiri — selalu pakai kelas ini.
// ═══════════════════════════════════════════════════════════════════════════

abstract class Validators {
  // ─── USERNAME ────────────────────────────────────────────────────────────
  /// Aturan: 3-20 karakter, hanya huruf/angka/underscore, tanpa spasi.
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username wajib diisi';
    }
    if (value.length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (value.length > 20) {
      return 'Username maksimal 20 karakter';
    }
    final noSpace = RegExp(r'^\S+$');
    if (!noSpace.hasMatch(value)) {
      return 'Username tidak boleh mengandung spasi';
    }
    final validChars = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!validChars.hasMatch(value)) {
      return 'Hanya huruf, angka, dan underscore (_)';
    }
    return null; // null = valid
  }

  // ─── EMAIL ───────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // ─── NIM / NO. HP ────────────────────────────────────────────────────────
  /// Aturan: hanya angka, 8-16 digit.
  static String? nimOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM / No. HP wajib diisi';
    }
    final numericOnly = RegExp(r'^\d+$');
    if (!numericOnly.hasMatch(value)) {
      return 'Hanya boleh berisi angka';
    }
    if (value.length < 8) {
      return 'Minimal 8 digit';
    }
    if (value.length > 16) {
      return 'Maksimal 16 digit';
    }
    return null;
  }

  // ─── PASSWORD ────────────────────────────────────────────────────────────
  /// Aturan: min 8 karakter, wajib ada huruf kapital, huruf kecil, dan angka.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Wajib mengandung minimal 1 huruf kapital';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Wajib mengandung minimal 1 huruf kecil';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Wajib mengandung minimal 1 angka';
    }
    return null;
  }

  // ─── KONFIRMASI PASSWORD ─────────────────────────────────────────────────
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != original) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // ─── NAMA PLAYLIST ───────────────────────────────────────────────────────
  static String? playlistName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama playlist wajib diisi';
    }
    if (value.trim().length > 50) {
      return 'Nama playlist maksimal 50 karakter';
    }
    return null;
  }
}
