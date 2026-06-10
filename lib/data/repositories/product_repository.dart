import 'package:drift/drift.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/media/media_cache_service.dart';

/// Read-only product access (products are master data — devices never write
/// them). Images resolve to locally cached files when downloaded.
class ProductRepository {
  ProductRepository(this._db) : _media = MediaCacheService(_db);

  final AppDatabase _db;
  final MediaCacheService _media;

  Stream<List<Product>> watchProducts() => (_db.select(_db.products)
        ..where((t) => t.isEnabled.equals(true))
        ..orderBy([
          (t) => OrderingTerm.asc(t.displayOrder),
          (t) => OrderingTerm.asc(t.productName),
        ]))
      .watch();

  Future<List<Product>> allProducts() => (_db.select(_db.products)
        ..where((t) => t.isEnabled.equals(true))
        ..orderBy([
          (t) => OrderingTerm.asc(t.displayOrder),
          (t) => OrderingTerm.asc(t.productName),
        ]))
      .get();

  Future<List<Product>> byIds(List<String> ids) => ids.isEmpty
      ? Future.value(<Product>[])
      : (_db.select(_db.products)..where((t) => t.id.isIn(ids))).get();

  /// Local file path of the product's primary image, or null when not yet
  /// downloaded (UI falls back to the remote presigned URL when online).
  Future<String?> localImagePath(String productId) =>
      _media.localPathForProduct(productId);
}
