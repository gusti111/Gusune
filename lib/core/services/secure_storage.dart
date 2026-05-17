import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  SECURE STORAGE SERVICE
//  Satu-satunya titik akses untuk operasi token & sesi pengguna.
//  Semua key disentralisasi di sini agar tidak ada typo di tempat lain.
// ═══════════════════════════════════════════════════════════════════════════

/// Key constants — tidak ada string literal token di luar file ini.
abstract class _StorageKeys {
  static const sessionToken  = 'session_token';
  static const username      = 'user_username';
  static const email         = 'user_email';
  static const nimOrPhone    = 'user_nim_or_phone';
  static const rememberMe    = 'remember_me';
}

class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  // ─── SESI & TOKEN ─────────────────────────────────────────────────────

  /// Simpan token sesi setelah login berhasil.
  Future<void> saveSession({
    required String token,
    required String username,
    required String email,
    required String nimOrPhone,
    required bool rememberMe,
  }) async {
    await Future.wait([
      _storage.write(key: _StorageKeys.sessionToken, value: token),
      _storage.write(key: _StorageKeys.username,     value: username),
      _storage.write(key: _StorageKeys.email,        value: email),
      _storage.write(key: _StorageKeys.nimOrPhone,   value: nimOrPhone),
      _storage.write(
        key: _StorageKeys.rememberMe,
        value: rememberMe.toString(),
      ),
    ]);
  }

  /// Baca token sesi. Mengembalikan null jika belum login.
  Future<String?> getSessionToken() async {
    return _storage.read(key: _StorageKeys.sessionToken);
  }

  /// Cek apakah sesi valid (token ada dan tidak kosong).
  Future<bool> isLoggedIn() async {
    final token = await getSessionToken();
    return token != null && token.isNotEmpty;
  }

  /// Baca data profil pengguna dari storage.
  Future<UserSession?> getUserSession() async {
    final token      = await _storage.read(key: _StorageKeys.sessionToken);
    final username   = await _storage.read(key: _StorageKeys.username);
    final email      = await _storage.read(key: _StorageKeys.email);
    final nimOrPhone = await _storage.read(key: _StorageKeys.nimOrPhone);
    final rememberMe = await _storage.read(key: _StorageKeys.rememberMe);

    if (token == null || username == null || email == null) return null;

    return UserSession(
      token:      token,
      username:   username,
      email:      email,
      nimOrPhone: nimOrPhone ?? '',
      rememberMe: rememberMe == 'true',
    );
  }

  /// Hapus semua data sesi (logout).
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _StorageKeys.sessionToken),
      _storage.delete(key: _StorageKeys.username),
      _storage.delete(key: _StorageKeys.email),
      _storage.delete(key: _StorageKeys.nimOrPhone),
      _storage.delete(key: _StorageKeys.rememberMe),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  DATA MODEL — UserSession
//  Model sederhana untuk data pengguna yang tersimpan di sesi.
//  Bukan dari database Isar — ini hanya data aktif login.
// ═══════════════════════════════════════════════════════════════════════════

class UserSession {
  final String token;
  final String username;
  final String email;
  final String nimOrPhone;
  final bool rememberMe;

  const UserSession({
    required this.token,
    required this.username,
    required this.email,
    required this.nimOrPhone,
    required this.rememberMe,
  });

  /// Inisial username untuk Avatar (maks 2 karakter).
  /// Contoh: "budi_pratama" → "BP" | "rara" → "RA"
  String get initials {
    final parts = username.split(RegExp(r'[_\s]+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username.substring(0, username.length.clamp(0, 2)).toUpperCase();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});

/// Provider untuk data sesi pengguna aktif.
/// Digunakan di Profile Page dan AppBar untuk menampilkan username/avatar.
final userSessionProvider = FutureProvider<UserSession?>((ref) async {
  final service = ref.watch(secureStorageServiceProvider);
  return service.getUserSession();
});
