import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/media/media_cache_service.dart';

/// Read-only product access (products are master data — devices never write
/// them), plus a device-local presentation order so each rep can arrange
/// products the way they pitch them. Images resolve to locally cached files
/// when downloaded.
class ProductRepository {
  ProductRepository(this._db) : _media = MediaCacheService(_db);

  final AppDatabase _db;
  final MediaCacheService _media;

  static const String _localOrderKey = 'product_local_order_v1';

  Stream<List<Product>> watchProducts() =>
      (_db.select(_db.products)
            ..where((t) => t.isEnabled.equals(true))
            ..orderBy([
              (t) => OrderingTerm.asc(t.displayOrder),
              (t) => OrderingTerm.asc(t.productName),
            ]))
          .watch();

  /// Products in presentation order: the rep's local arrangement first,
  /// then any new products (not yet arranged) in the server's order.
  Future<List<Product>> allProducts() async {
    final List<Product> products =
        await (_db.select(_db.products)
              ..where((t) => t.isEnabled.equals(true))
              ..orderBy([
                (t) => OrderingTerm.asc(t.displayOrder),
                (t) => OrderingTerm.asc(t.productName),
              ]))
            .get();

    final List<String> localOrder = await loadLocalOrder();
    if (localOrder.isEmpty) {
      return products;
    }
    final Map<String, int> rank = <String, int>{
      for (int i = 0; i < localOrder.length; i++) localOrder[i]: i,
    };
    final List<Product> arranged =
        products.where((p) => rank.containsKey(p.id)).toList(growable: false)
          ..sort((a, b) => rank[a.id]!.compareTo(rank[b.id]!));
    final List<Product> unarranged = products
        .where((p) => !rank.containsKey(p.id))
        .toList(growable: false);
    return <Product>[...arranged, ...unarranged];
  }

  /// Persists the rep's local presentation order (device-only preference —
  /// never synced to the server).
  Future<void> saveLocalOrder(List<String> productIds) =>
      _db.setKv(_localOrderKey, jsonEncode(productIds));

  Future<List<String>> loadLocalOrder() async {
    final String? raw = await _db.getKv(_localOrderKey);
    if (raw == null || raw.isEmpty) {
      return const <String>[];
    }
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((dynamic id) => id.toString())
          .toList(growable: false);
    } catch (_) {
      return const <String>[];
    }
  }

  Future<void> resetLocalOrder() => _db.setKv(_localOrderKey, null);

  Future<List<Product>> byIds(List<String> ids) => ids.isEmpty
      ? Future.value(<Product>[])
      : (_db.select(_db.products)..where((t) => t.id.isIn(ids))).get();

  /// Local file path of the product's primary image, or null when not yet
  /// downloaded (UI falls back to the remote presigned URL when online).
  Future<String?> localImagePath(String productId) =>
      _media.localPathForProduct(productId);
}
