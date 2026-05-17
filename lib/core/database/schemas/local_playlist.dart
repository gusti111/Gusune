// GENERATED CODE TARGET — build_runner akan membuat local_playlist.g.dart

import 'package:isar/isar.dart';

import 'offline_track.dart';

part '../../../local_playlist.g.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  SKEMA: LocalPlaylist
//  Tabel daftar putar milik pengguna.
//
//  Relasi: Satu playlist → banyak OfflineTrack (Many-to-Many via IsarLinks).
//  File audio TIDAK diduplikasi. Isar hanya menyimpan referensi (link) ID.
//  Artinya: lagu yang sama bisa ada di 10 playlist tanpa memakan 10x storage.
// ═══════════════════════════════════════════════════════════════════════════

@Collection()
class LocalPlaylist {
  // ─── Primary Key ──────────────────────────────────────────────────────
  Id id = Isar.autoIncrement;

  // ─── Identitas Playlist ───────────────────────────────────────────────
  /// Nama playlist yang diinput pengguna.
  /// Contoh: "Fokus Koding 🎧", "Lari Pagi", "Nemenin Skripsi"
  @Index(type: IndexType.value)
  late String name;

  /// Deskripsi opsional untuk playlist.
  /// Nullable — pengguna tidak wajib mengisi.
  String? description;

  // ─── Metadata Visual ──────────────────────────────────────────────────
  /// Path gambar sampul playlist kustom (jika pengguna set sendiri).
  /// Jika null → UI akan auto-generate collage dari 4 album art pertama.
  String? coverImagePath;

  /// Warna aksen playlist (hex string). Untuk UI card playlist.
  /// Jika null → gunakan warna primary dari theme.
  /// Contoh: "#FF6B35" (oranye), "#4A90D9" (biru)
  String? accentColorHex;

  // ─── Timestamp ────────────────────────────────────────────────────────
  /// Waktu playlist dibuat. Untuk pengurutan default di Library.
  late DateTime createdAt;

  /// Waktu terakhir playlist dimodifikasi (lagu ditambah/dihapus).
  /// Di-update setiap kali operasi `addTrack` atau `removeTrack` dipanggil.
  late DateTime updatedAt;

  // ─── Relasi Many-to-Many ──────────────────────────────────────────────
  /// Daftar lagu dalam playlist ini.
  /// IsarLinks = relasi lazy — data lagu tidak dimuat ke memori
  /// sampai .load() dipanggil secara eksplisit di repository.
  /// Ini mencegah loading seluruh library saat hanya butuh nama playlist.
  final tracks = IsarLinks<OfflineTrack>();

  // ─── Status ───────────────────────────────────────────────────────────
  /// Tandai apakah ini playlist "Liked Songs" bawaan sistem.
  /// Playlist ini tidak bisa dihapus pengguna.
  bool isDefault = false;
}

// ─── Helper Extension ─────────────────────────────────────────────────────
extension LocalPlaylistX on LocalPlaylist {
  /// Hitung total durasi playlist dalam format "X jam Y menit".
  /// Membutuhkan tracks sudah di-load terlebih dahulu.
  String get totalDurationFormatted {
    // tracks.toList() hanya valid setelah .load() dipanggil di repository
    int totalSeconds = 0;
    for (final track in tracks) {
      totalSeconds += track.durationSeconds;
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return '$hours jam $minutes menit';
    return '$minutes menit';
  }

  /// Hitung total ukuran semua lagu dalam playlist.
  String get totalSizeFormatted {
    int totalBytes = 0;
    for (final track in tracks) {
      totalBytes += track.sizeInBytes;
    }
    if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Jumlah lagu yang valid (file fisiknya masih ada).
  int get validTrackCount => tracks.where((t) => t.isFileValid).length;
}
