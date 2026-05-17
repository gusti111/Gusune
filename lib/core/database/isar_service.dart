import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'lib/core/database/schemas/offline_track.dart';
import 'lib/core/database/schemas/local_playlist.dart';
import 'lib/core/database/repositories/track_repository.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  ISAR SERVICE — Inisialisasi & Provider Layer
//
//  Kelas ini bertanggung jawab untuk:
//  1. Membuka koneksi database Isar (dipanggil sekali di main.dart)
//  2. Menyediakan instance Isar ke seluruh aplikasi via Riverpod
//  3. Menyediakan instance TrackRepository via Riverpod
// ═══════════════════════════════════════════════════════════════════════════

class IsarService {
  // Singleton — hanya satu instance database yang boleh terbuka sekaligus
  static Isar? _instance;

  /// Buka koneksi database. Dipanggil sekali di `main()` sebelum `runApp()`.
  /// Jika sudah terbuka, mengembalikan instance yang ada (idempotent).
  static Future<Isar> initialize() async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    // Dapatkan path direktori yang aman (bukan folder publik HP)
    final dir = await getApplicationSupportDirectory();

    _instance = await Isar.open(
      [
        OfflineTrackSchema, // Auto-generated oleh build_runner
        LocalPlaylistSchema, // Auto-generated oleh build_runner
      ],
      directory: dir.path,
      name: 'gustune_db', // Nama file .isar di storage
      inspector: true, // Aktifkan Isar Inspector untuk debugging
      // (set false saat release/production)
    );

    return _instance!;
  }

  /// Tutup koneksi database. Dipanggil saat app dihancurkan (dispose).
  static Future<void> close() async {
    if (_instance != null && _instance!.isOpen) {
      await _instance!.close();
      _instance = null;
    }
  }

  /// Akses instance yang sudah terbuka. Throw jika belum diinisialisasi.
  static Isar get instance {
    if (_instance == null || !_instance!.isOpen) {
      throw StateError(
        '[IsarService] Database belum diinisialisasi. '
        'Panggil IsarService.initialize() di main() sebelum runApp().',
      );
    }
    return _instance!;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  RIVERPOD PROVIDERS
//  Provider ini membuat Isar dan TrackRepository tersedia di seluruh widget tree
//  tanpa perlu passing manual lewat constructor (dependency injection otomatis).
// ═══════════════════════════════════════════════════════════════════════════

/// Provider untuk instance Isar.
/// Digunakan jika ada fitur yang butuh akses langsung ke Isar
/// (misalnya untuk query custom di luar TrackRepository).
final isarProvider = Provider<Isar>((ref) {
  return IsarService.instance;
});

/// Provider untuk TrackRepository.
/// Ini adalah provider yang paling sering digunakan oleh fitur-fitur lain.
///
/// Contoh penggunaan di widget:
///   final repo = ref.read(trackRepositoryProvider);
///   final tracks = await repo.getAllTracks();
final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return TrackRepository(isar);
});

/// Provider untuk total ukuran storage yang dipakai (dalam bytes).
/// Digunakan di Profile → Storage Indicator.
/// FutureProvider agar bisa di-await secara reaktif.
final storageUsedProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(trackRepositoryProvider);
  return repo.getTotalStorageUsed();
});

/// Provider untuk daftar semua lagu offline (sudah tervalidasi).
/// Auto-refresh setiap kali ada perubahan di database.
final offlineTracksProvider = FutureProvider<List<OfflineTrack>>((ref) async {
  final repo = ref.watch(trackRepositoryProvider);
  return repo.getAllTracks();
});

/// Provider untuk daftar semua playlist.
final playlistsProvider = FutureProvider<List<LocalPlaylist>>((ref) async {
  final repo = ref.watch(trackRepositoryProvider);
  return repo.getAllPlaylists();
});
