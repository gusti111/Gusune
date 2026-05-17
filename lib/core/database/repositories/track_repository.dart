import 'dart:io';

import 'package:isar/isar.dart';

import '../schemas/offline_track.dart';
import '../schemas/local_playlist.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  TRACK REPOSITORY
//  Satu-satunya pintu masuk ke operasi database Isar.
//  Tidak ada widget atau provider yang boleh memanggil Isar secara langsung.
//  Semua operasi CRUD dan validasi file melewati kelas ini.
// ═══════════════════════════════════════════════════════════════════════════

class TrackRepository {
  final Isar _isar;

  const TrackRepository(this._isar);

  // ═══════════════════════════════════════════════════════════════════════
  //  BAGIAN 1: OPERASI OfflineTrack (CRUD + Validasi)
  // ═══════════════════════════════════════════════════════════════════════

  // ─── CREATE ─────────────────────────────────────────────────────────────

  /// Menyimpan satu lagu unduhan ke database.
  /// Jika ytId sudah ada (replace: true di schema), data lama akan diganti.
  /// Mengembalikan ID baris yang baru dibuat.
  Future<Id> saveTrack(OfflineTrack track) async {
    return await _isar.writeTxn(() async {
      return await _isar.offlineTracks.put(track);
    });
  }

  // ─── READ ────────────────────────────────────────────────────────────────

  /// Ambil semua lagu yang sudah diunduh, diurutkan dari terbaru.
  /// PENTING: Fungsi ini juga menjalankan validasi file fisik secara otomatis.
  /// Lagu yang file-nya hilang akan di-flag isFileValid = false.
  Future<List<OfflineTrack>> getAllTracks() async {
    final tracks = await _isar.offlineTracks
        .where()
        .sortByDownloadedAtDesc()
        .findAll();

    // ─── Auto-Validation Logic ─────────────────────────────────────────
    // Mitigasi celah file system mismatch:
    // Jika pengguna menggunakan cleaner app yang menghapus file fisik,
    // database masih mencatat lagu "tersedia". Ini akan crash saat diputar.
    // Solusi: cek eksistensi fisik, update flag, bersihkan baris invalid.
    await _validateAndCleanTracks(tracks);

    return await _isar.offlineTracks
        .where()
        .filter()
        .isFileValidEqualTo(true)
        .sortByDownloadedAtDesc()
        .findAll();
  }

  /// Cari lagu berdasarkan judul (Full-Text Search via Isar index).
  Future<List<OfflineTrack>> searchTracks(String query) async {
    if (query.trim().isEmpty) return getAllTracks();
    return await _isar.offlineTracks
        .where()
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .artistContains(query, caseSensitive: false)
        .isFileValidEqualTo(true)
        .findAll();
  }

  /// Cek apakah lagu dengan ytId tertentu sudah diunduh.
  Future<bool> isTrackDownloaded(String ytId) async {
    final track = await _isar.offlineTracks
        .where()
        .ytIdEqualTo(ytId)
        .findFirst();
    if (track == null) return false;
    // Double-check: pastikan file fisiknya benar-benar ada
    return File(track.localPath).existsSync();
  }

  /// Ambil satu lagu berdasarkan ytId. Mengembalikan null jika tidak ada.
  Future<OfflineTrack?> getTrackByYtId(String ytId) async {
    return await _isar.offlineTracks.where().ytIdEqualTo(ytId).findFirst();
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────

  /// Hapus satu lagu dari database DAN file fisiknya dari memori HP.
  /// Mengembalikan true jika berhasil, false jika gagal.
  Future<bool> deleteTrack(Id trackId) async {
    try {
      final track = await _isar.offlineTracks.get(trackId);
      if (track == null) return false;

      // 1. Hapus file fisik .m4a terlebih dahulu
      final file = File(track.localPath);
      if (await file.exists()) {
        await file.delete();
      }

      // 2. Baru hapus baris dari database
      await _isar.writeTxn(() async {
        await _isar.offlineTracks.delete(trackId);
      });

      return true;
    } catch (e) {
      // Log error untuk debugging — jangan crash app
      debugPrint('[TrackRepository] deleteTrack error: $e');
      return false;
    }
  }

  /// Hapus semua lagu yang file fisiknya sudah tidak ada (cleanup massal).
  /// Dipanggil dari Profile → "Clear Cache" atau saat buka Library.
  Future<int> deleteInvalidTracks() async {
    final invalidTracks = await _isar.offlineTracks
        .where()
        .filter()
        .isFileValidEqualTo(false)
        .findAll();

    await _isar.writeTxn(() async {
      final ids = invalidTracks.map((t) => t.id).toList();
      await _isar.offlineTracks.deleteAll(ids);
    });

    return invalidTracks.length; // Kembalikan jumlah baris yang dihapus
  }

  // ─── STORAGE METRICS ─────────────────────────────────────────────────────

  /// Hitung total ukuran semua lagu yang tersimpan (untuk Storage Indicator).
  /// Mengembalikan nilai dalam bytes.
  Future<int> getTotalStorageUsed() async {
    final tracks = await _isar.offlineTracks
        .where()
        .filter()
        .isFileValidEqualTo(true)
        .findAll();

    return tracks.fold(0, (sum, track) => sum + track.sizeInBytes);
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BAGIAN 2: OPERASI LocalPlaylist (CRUD + Manajemen Trek)
  // ═══════════════════════════════════════════════════════════════════════

  // ─── CREATE ─────────────────────────────────────────────────────────────

  /// Buat playlist baru. Otomatis membuat "Liked Songs" jika belum ada.
  Future<LocalPlaylist> createPlaylist({
    required String name,
    String? description,
    bool isDefault = false,
  }) async {
    final now = DateTime.now();
    final playlist = LocalPlaylist()
      ..name = name
      ..description = description
      ..createdAt = now
      ..updatedAt = now
      ..isDefault = isDefault;

    await _isar.writeTxn(() async {
      await _isar.localPlaylists.put(playlist);
    });

    return playlist;
  }

  /// Inisialisasi "Liked Songs" — dipanggil sekali saat app pertama dijalankan.
  Future<void> ensureDefaultPlaylistExists() async {
    final exists = await _isar.localPlaylists
        .where()
        .filter()
        .isDefaultEqualTo(true)
        .count();

    if (exists == 0) {
      await createPlaylist(
        name: 'Liked Songs',
        description: 'Lagu yang kamu suka',
        isDefault: true,
      );
    }
  }

  // ─── READ ────────────────────────────────────────────────────────────────

  /// Ambil semua playlist, diurutkan berdasarkan updatedAt (terbaru dulu).
  /// "Liked Songs" selalu di posisi pertama.
  Future<List<LocalPlaylist>> getAllPlaylists() async {
    final all = await _isar.localPlaylists
        .where()
        .sortByUpdatedAtDesc()
        .findAll();

    // Load semua relasi tracks secara lazy
    for (final playlist in all) {
      await playlist.tracks.load();
    }

    // "Liked Songs" selalu di depan
    all.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return all;
  }

  /// Ambil satu playlist berdasarkan ID (dengan tracks ter-load).
  Future<LocalPlaylist?> getPlaylistById(Id playlistId) async {
    final playlist = await _isar.localPlaylists.get(playlistId);
    if (playlist == null) return null;
    await playlist.tracks.load();
    return playlist;
  }

  // ─── UPDATE — Manajemen Trek dalam Playlist ───────────────────────────────

  /// Tambahkan lagu ke playlist.
  /// Mengembalikan false jika lagu sudah ada dalam playlist (duplikasi dicegah).
  Future<bool> addTrackToPlaylist({
    required Id playlistId,
    required Id trackId,
  }) async {
    final playlist = await _isar.localPlaylists.get(playlistId);
    final track = await _isar.offlineTracks.get(trackId);

    if (playlist == null || track == null) return false;

    await playlist.tracks.load();

    // Cegah duplikasi
    if (playlist.tracks.any((t) => t.id == trackId)) return false;

    await _isar.writeTxn(() async {
      playlist.tracks.add(track);
      await playlist.tracks.save();

      // Update timestamp
      playlist.updatedAt = DateTime.now();
      await _isar.localPlaylists.put(playlist);
    });

    return true;
  }

  /// Hapus lagu dari playlist (bukan menghapus file fisiknya).
  Future<bool> removeTrackFromPlaylist({
    required Id playlistId,
    required Id trackId,
  }) async {
    final playlist = await _isar.localPlaylists.get(playlistId);
    if (playlist == null) return false;

    await playlist.tracks.load();

    await _isar.writeTxn(() async {
      playlist.tracks.removeWhere((t) => t.id == trackId);
      await playlist.tracks.save();

      playlist.updatedAt = DateTime.now();
      await _isar.localPlaylists.put(playlist);
    });

    return true;
  }

  /// Rename playlist. Playlist default (Liked Songs) tidak bisa di-rename.
  Future<bool> renamePlaylist(Id playlistId, String newName) async {
    final playlist = await _isar.localPlaylists.get(playlistId);
    if (playlist == null || playlist.isDefault) return false;

    await _isar.writeTxn(() async {
      playlist.name = newName;
      playlist.updatedAt = DateTime.now();
      await _isar.localPlaylists.put(playlist);
    });

    return true;
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────

  /// Hapus playlist. Playlist default tidak bisa dihapus.
  /// File audio lagu di dalamnya TIDAK ikut dihapus (hanya relasi yang putus).
  Future<bool> deletePlaylist(Id playlistId) async {
    final playlist = await _isar.localPlaylists.get(playlistId);
    if (playlist == null || playlist.isDefault) return false;

    await _isar.writeTxn(() async {
      // Putuskan semua relasi ke tracks dulu
      await playlist.tracks.load();
      playlist.tracks.clear();
      await playlist.tracks.save();

      // Baru hapus playlist-nya
      await _isar.localPlaylists.delete(playlistId);
    });

    return true;
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BAGIAN 3: INTERNAL HELPERS (Private)
  // ═══════════════════════════════════════════════════════════════════════

  /// Validasi keberadaan file fisik untuk semua track.
  /// Track yang file-nya hilang di-flag false dan dibersihkan dari DB.
  Future<void> _validateAndCleanTracks(List<OfflineTrack> tracks) async {
    final List<OfflineTrack> toUpdate = [];

    for (final track in tracks) {
      final fileExists = File(track.localPath).existsSync();
      if (track.isFileValid != fileExists) {
        track.isFileValid = fileExists;
        toUpdate.add(track);
      }
    }

    if (toUpdate.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.offlineTracks.putAll(toUpdate);
      });
    }

    // Hapus baris yang invalid dari database (auto-cleanup)
    await deleteInvalidTracks();
  }
}

// Alias untuk debugPrint agar tidak perlu import dart:developer
void debugPrint(String message) {
  // ignore: avoid_print
  print('[GUSTUNE-DB] $message');
}
