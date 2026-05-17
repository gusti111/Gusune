// GENERATED CODE TARGET — Jalankan perintah ini setelah file ini dibuat:
// dart run build_runner build --delete-conflicting-outputs
//
// File yang akan di-generate otomatis oleh Isar:
// offline_track.g.dart (jangan edit manual, akan ditimpa build_runner)

import 'package:isar/isar.dart';

part '../../../offline_track.g.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  SKEMA: OfflineTrack
//  Tabel penyimpanan metadata lagu yang sudah diunduh ke memori HP.
//  Setiap baris merepresentasikan SATU file audio fisik (.m4a terenkripsi).
// ═══════════════════════════════════════════════════════════════════════════

@Collection()
class OfflineTrack {
  // ─── Primary Key ──────────────────────────────────────────────────────
  /// ID auto-increment dari Isar. Jangan di-set manual.
  Id id = Isar.autoIncrement;

  // ─── Identitas Lagu (dari YouTube) ────────────────────────────────────
  /// ID unik YouTube (contoh: "dQw4w9WgXcQ").
  /// Di-index agar query `findByYtId` berjalan dalam O(1), bukan O(n).
  /// Digunakan untuk mencegah duplikasi unduhan lagu yang sama.
  @Index(unique: true, replace: true)
  late String ytId;

  /// Judul lagu. Di-index untuk mendukung Full-Text Search di Library.
  @Index(type: IndexType.value)
  late String title;

  /// Nama artis / channel pengunggah.
  late String artist;

  /// URL gambar sampul album (dari YouTube thumbnail).
  /// Di-cache ke disk oleh flutter_cache_manager saat pertama kali dimuat.
  late String albumArtUrl;

  // ─── Lokasi File Fisik ────────────────────────────────────────────────
  /// Path absolut ke file .m4a terenkripsi di App Support Directory.
  /// Contoh: /data/user/0/com.gustune.app/files/audio/dQw4w9WgXcQ.m4a
  late String localPath;

  /// Ukuran file dalam bytes. Digunakan untuk kalkulasi Storage di profil.
  /// Contoh: 4500000 = ~4.5 MB
  late int sizeInBytes;

  // ─── Durasi ───────────────────────────────────────────────────────────
  /// Durasi lagu dalam detik. Untuk menampilkan "03:45" di UI.
  late int durationSeconds;

  // ─── Timestamp ────────────────────────────────────────────────────────
  /// Waktu saat unduhan selesai. Untuk pengurutan "Baru Ditambahkan".
  late DateTime downloadedAt;

  // ─── Status & Validasi ────────────────────────────────────────────────
  /// Flag validitas file fisik.
  /// true  = file ada dan bisa diputar.
  /// false = file hilang (dihapus pihak ketiga / pembersih memori HP).
  ///
  /// Di-set ulang oleh track_repository.dart setiap kali library dibuka
  /// melalui fungsi File(localPath).existsSync().
  @Index()
  bool isFileValid = true;

  // ─── Back-link untuk relasi ke LocalPlaylist ───────────────────────────
  /// Relasi balik (inverse) dari LocalPlaylist.tracks.
  /// Memungkinkan query: "lagu ini ada di playlist mana saja?"
  final playlists = IsarLinks<LocalPlaylist>();
}

// ─── Helper Extension ─────────────────────────────────────────────────────
/// Ekstensi untuk konversi data yang sering dipakai di UI layer.
extension OfflineTrackX on OfflineTrack {
  /// Konversi durationSeconds → format "mm:ss" untuk ditampilkan.
  /// Contoh: 225 → "3:45"
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Konversi sizeInBytes → format human-readable.
  /// Contoh: 4500000 → "4.3 MB"
  String get formattedSize {
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Ambil inisial artis untuk fallback Avatar (jika gambar gagal load).
  /// Contoh: "Tulus" → "T" | "Hindia & Sal Priadi" → "H"
  String get artistInitial =>
      artist.isNotEmpty ? artist[0].toUpperCase() : '?';
}

// Circular import resolver — LocalPlaylist dideklarasikan di file terpisah
// tapi Isar membutuhkan referensinya di sini untuk IsarLinks.
// Import ini akan di-resolve oleh build_runner saat generate .g.dart
import 'local_playlist.dart';
