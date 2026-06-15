import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vivocure/core/db/app_database.dart';

/// Downloads and serves media (product images / presentation assets) for
/// offline use. Entries are registered by the pull service keyed on the R2
/// object key; presigned URLs are re-read from the owning entity row at
/// download time because they expire (~10h) while object keys are stable.
class MediaCacheService {
  MediaCacheService(this._db, {http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final AppDatabase _db;
  final http.Client _http;

  static const String _folder = 'media_cache';

  Future<Directory> _cacheDir() async {
    final Directory base = await getApplicationSupportDirectory();
    final Directory dir = Directory(p.join(base.path, _folder));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Media entry states:
  ///  - pending     : not yet attempted
  ///  - downloaded  : cached on disk, served offline
  ///  - failed      : transient failure (timeout / 5xx / expired URL) — retried
  ///  - missing     : object genuinely absent on the server (404/410) or the
  ///                  URL is invalid — permanent, never retried (UI shows a
  ///                  placeholder instead)
  static const String _stateDownloaded = 'downloaded';
  static const String _stateFailed = 'failed';
  static const String _stateMissing = 'missing';

  /// Best-effort download of all pending/retryable media. Never throws — media
  /// must not block data sync. Permanently `missing` entries are skipped so a
  /// 404'd asset isn't re-requested on every sync.
  Future<void> downloadPending({int maxConcurrent = 3}) async {
    final List<MediaCacheEntry> pending =
        await (_db.select(_db.mediaCacheEntries)..where(
              (t) =>
                  t.state.isNotValue(_stateDownloaded) &
                  t.state.isNotValue(_stateMissing),
            ))
            .get();
    if (pending.isEmpty) {
      return;
    }
    final Directory dir = await _cacheDir();
    for (int i = 0; i < pending.length; i += maxConcurrent) {
      final batch = pending.skip(i).take(maxConcurrent);
      await Future.wait(batch.map((e) => _download(e, dir)));
    }
  }

  Future<void> _download(MediaCacheEntry entry, Directory dir) async {
    try {
      final String? url = await _resolveUrl(entry);
      if (url == null || url.isEmpty) {
        // URL not available yet (owning entity not pulled): leave for a later
        // sync to supply it. Not a failure.
        return;
      }
      final Uri? uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        debugPrint('[MEDIA] invalid URL for ${entry.objectKey} — skipping');
        await _setState(entry, _stateMissing);
        return;
      }

      final http.Response response = await _http
          .get(uri)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final String fileName = entry.objectKey.replaceAll(
          RegExp(r'[^\w.]+'),
          '_',
        );
        final File file = File(p.join(dir.path, fileName));
        await file.writeAsBytes(response.bodyBytes, flush: true);
        await _db
            .into(_db.mediaCacheEntries)
            .insertOnConflictUpdate(
              entry.copyWith(
                localPath: Value(file.path),
                state: _stateDownloaded,
                fetchedAt: Value(DateTime.now().toUtc().toIso8601String()),
              ),
            );
        return;
      }

      // 404/410: the object isn't on the server. This won't fix itself, so
      // mark it permanently missing and stop retrying — the UI falls back to a
      // placeholder image.
      if (response.statusCode == 404 || response.statusCode == 410) {
        debugPrint(
          '[MEDIA] asset missing (${response.statusCode}) '
          '${entry.objectKey} — will show placeholder',
        );
        await _setState(entry, _stateMissing);
        return;
      }

      // Everything else (403 expired presigned URL, 5xx, etc.) is transient:
      // keep it retryable so the next sync (with a refreshed URL) can succeed.
      debugPrint(
        '[MEDIA] transient failure (${response.statusCode}) '
        '${entry.objectKey} — will retry',
      );
      await _setState(entry, _stateFailed);
    } catch (error) {
      // Network/timeout/IO error — transient, retry on the next sync.
      debugPrint('[MEDIA] download error ${entry.objectKey}: $error');
      await _setState(entry, _stateFailed);
    }
  }

  Future<void> _setState(MediaCacheEntry entry, String state) => _db
      .into(_db.mediaCacheEntries)
      .insertOnConflictUpdate(entry.copyWith(state: state));

  /// Presigned URL for the entry's object key, read from the owning product
  /// row (refreshed on every pull).
  Future<String?> _resolveUrl(MediaCacheEntry entry) async {
    if (entry.entity != 'products' || entry.entityId == null) {
      return null;
    }
    final Product? product = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(entry.entityId!))).getSingleOrNull();
    final String? json = product?.imageUrlsJson;
    if (json == null) {
      return null;
    }
    final match = RegExp(
      '"object_key"\\s*:\\s*"${RegExp.escape(entry.objectKey)}"[^}]*"url"\\s*:\\s*"([^"]+)"',
    ).firstMatch(json);
    if (match != null) {
      return match.group(1)?.replaceAll(r'\/', '/');
    }
    // url may precede object_key in the JSON; fall back to a tolerant scan.
    final alt = RegExp(
      '"url"\\s*:\\s*"([^"]+)"[^}]*"object_key"\\s*:\\s*"${RegExp.escape(entry.objectKey)}"',
    ).firstMatch(json);
    return alt?.group(1)?.replaceAll(r'\/', '/');
  }

  /// Local path for a product's primary image, if downloaded.
  Future<String?> localPathForProduct(String productId) async {
    final MediaCacheEntry? entry =
        await (_db.select(_db.mediaCacheEntries)
              ..where(
                (t) =>
                    t.entityId.equals(productId) & t.state.equals('downloaded'),
              )
              ..limit(1))
            .getSingleOrNull();
    final String? path = entry?.localPath;
    if (path == null) {
      return null;
    }
    return await File(path).exists() ? path : null;
  }

  Future<void> clearAll() async {
    final Directory dir = await _cacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await _db.delete(_db.mediaCacheEntries).go();
  }
}
