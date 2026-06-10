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

  /// Best-effort download of all pending media. Never throws — media must not
  /// block data sync.
  Future<void> downloadPending({int maxConcurrent = 3}) async {
    final List<MediaCacheEntry> pending =
        await (_db.select(_db.mediaCacheEntries)
              ..where((t) => t.state.isNotValue('downloaded')))
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
        return;
      }
      final http.Response response =
          await _http.get(Uri.parse(url)).timeout(const Duration(seconds: 60));
      if (response.statusCode != 200) {
        throw HttpException('status ${response.statusCode}');
      }
      final String fileName = entry.objectKey.replaceAll(RegExp(r'[^\w.]+'), '_');
      final File file = File(p.join(dir.path, fileName));
      await file.writeAsBytes(response.bodyBytes, flush: true);
      await _db.into(_db.mediaCacheEntries).insertOnConflictUpdate(
            entry.copyWith(
              localPath: Value(file.path),
              state: 'downloaded',
              fetchedAt: Value(DateTime.now().toUtc().toIso8601String()),
            ),
          );
    } catch (error) {
      debugPrint('[MEDIA] download failed ${entry.objectKey}: $error');
      await _db.into(_db.mediaCacheEntries).insertOnConflictUpdate(
            entry.copyWith(state: 'failed'),
          );
    }
  }

  /// Presigned URL for the entry's object key, read from the owning product
  /// row (refreshed on every pull).
  Future<String?> _resolveUrl(MediaCacheEntry entry) async {
    if (entry.entity != 'products' || entry.entityId == null) {
      return null;
    }
    final Product? product = await (_db.select(_db.products)
          ..where((t) => t.id.equals(entry.entityId!)))
        .getSingleOrNull();
    final String? json = product?.imageUrlsJson;
    if (json == null) {
      return null;
    }
    final match = RegExp('"object_key"\\s*:\\s*"${RegExp.escape(entry.objectKey)}"[^}]*"url"\\s*:\\s*"([^"]+)"')
        .firstMatch(json);
    if (match != null) {
      return match.group(1)?.replaceAll(r'\/', '/');
    }
    // url may precede object_key in the JSON; fall back to a tolerant scan.
    final alt = RegExp('"url"\\s*:\\s*"([^"]+)"[^}]*"object_key"\\s*:\\s*"${RegExp.escape(entry.objectKey)}"')
        .firstMatch(json);
    return alt?.group(1)?.replaceAll(r'\/', '/');
  }

  /// Local path for a product's primary image, if downloaded.
  Future<String?> localPathForProduct(String productId) async {
    final MediaCacheEntry? entry = await (_db.select(_db.mediaCacheEntries)
          ..where((t) =>
              t.entityId.equals(productId) & t.state.equals('downloaded'))
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
