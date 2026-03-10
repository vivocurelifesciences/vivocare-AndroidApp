import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_exception.dart';

class ProductCacheService {
  ProductCacheService._();

  static const String _productsCacheKey = 'cached_products_dropdown_v1';
  static const String _cacheDirectoryName = 'product_images';

  static Future<void> syncProductsAfterLogin({
    required AuthSession session,
  }) async {
    final NetworkClient client = NetworkClient(
      scheme: ApiConfig.scheme,
      host: ApiConfig.host,
    );
    final http.Client imageClient = http.Client();

    try {
      final dynamic responseData = (await client.get(
        '${ApiConfig.apiVersionPath}/products/dropdown',
        headers: <String, String>{'Authorization': session.authorizationHeader},
      )).data;

      final Map<String, dynamic> root = _asMap(responseData);
      final dynamic rawItems = root['data'] ?? responseData;
      final List<dynamic> items = rawItems is List ? rawItems : <dynamic>[];

      final Directory cacheDirectory = await _getCacheDirectory();
      final List<CachedProduct> cachedProducts = <CachedProduct>[];

      for (final dynamic item in items) {
        final Map<String, dynamic> json = _asMap(item);
        final CachedProduct product = CachedProduct.fromJson(json);
        if (product.id.isEmpty || product.name.isEmpty) {
          continue;
        }

        String localImagePath = '';
        if (product.imageUrl.isNotEmpty) {
          try {
            localImagePath = await _downloadImage(
              client: imageClient,
              imageUrl: product.imageUrl,
              productId: product.id,
              cacheDirectory: cacheDirectory,
            );
          } catch (error) {
            debugPrintSynchronously(
              '[PRODUCTS] Failed to cache image for ${product.name}: $error',
            );
          }
        }

        cachedProducts.add(product.copyWith(localImagePath: localImagePath));
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _productsCacheKey,
        jsonEncode(
          cachedProducts
              .map((CachedProduct item) => item.toJson())
              .toList(growable: false),
        ),
      );

      debugPrintSynchronously(
        '[PRODUCTS] Cached ${cachedProducts.length} products locally.',
      );
    } finally {
      imageClient.close();
      client.close();
    }
  }

  static Future<List<CachedProduct>> loadCachedProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String rawJson = prefs.getString(_productsCacheKey) ?? '';
    if (rawJson.trim().isEmpty) {
      return const <CachedProduct>[];
    }

    final dynamic decoded = jsonDecode(rawJson);
    if (decoded is! List) {
      return const <CachedProduct>[];
    }

    return decoded
        .map<CachedProduct>(
          (dynamic item) => CachedProduct.fromJson(_asMap(item)),
        )
        .toList(growable: false);
  }

  static Future<void> clearCachedProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsCacheKey);

    try {
      final Directory cacheDirectory = await _getCacheDirectory();
      if (await cacheDirectory.exists()) {
        await cacheDirectory.delete(recursive: true);
      }
    } catch (error) {
      debugPrintSynchronously('[PRODUCTS] Failed to clear cached files: $error');
    }
  }

  static Future<Directory> _getCacheDirectory() async {
    final Directory root = await getApplicationSupportDirectory();
    final Directory cacheDirectory = Directory(
      '${root.path}/$_cacheDirectoryName',
    );
    if (!await cacheDirectory.exists()) {
      await cacheDirectory.create(recursive: true);
    }
    return cacheDirectory;
  }

  static Future<String> _downloadImage({
    required http.Client client,
    required String imageUrl,
    required String productId,
    required Directory cacheDirectory,
  }) async {
    final Uri uri = Uri.parse(imageUrl);
    final http.Response response = await client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NetworkException.fromStatusCode(
        statusCode: response.statusCode,
        message: 'Unable to download product image.',
        data: response.body,
      );
    }

    final String extension = _resolveFileExtension(
      uri.path,
      response.headers['content-type'],
    );
    final File file = File('${cacheDirectory.path}/$productId$extension');
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }

  static String _resolveFileExtension(String path, String? contentType) {
    final String lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.png')) {
      return '.png';
    }
    if (lowerPath.endsWith('.webp')) {
      return '.webp';
    }
    if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')) {
      return '.jpg';
    }

    final String normalizedType = (contentType ?? '').toLowerCase();
    if (normalizedType.contains('png')) {
      return '.png';
    }
    if (normalizedType.contains('webp')) {
      return '.webp';
    }
    return '.jpg';
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (Object? key, Object? item) =>
            MapEntry<String, dynamic>(key.toString(), item),
      );
    }
    return <String, dynamic>{};
  }
}

class CachedProduct {
  const CachedProduct({
    required this.id,
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.localImagePath,
  });

  final String id;
  final String name;
  final String code;
  final String imageUrl;
  final String localImagePath;

  CachedProduct copyWith({
    String? id,
    String? name,
    String? code,
    String? imageUrl,
    String? localImagePath,
  }) {
    return CachedProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'product_name': name,
      'product_code': code,
      'image_url': imageUrl,
      'local_image_path': localImagePath,
    };
  }

  factory CachedProduct.fromJson(Map<String, dynamic> json) {
    return CachedProduct(
      id: _readString(json['id']),
      name: _readString(json['product_name']).isEmpty
          ? _readString(json['name'])
          : _readString(json['product_name']),
      code: _readString(json['product_code']).isEmpty
          ? _readString(json['code'])
          : _readString(json['product_code']),
      imageUrl: _readString(json['image_url']),
      localImagePath: _readString(json['local_image_path']),
    );
  }

  static String _readString(Object? value) {
    if (value is String) {
      return value.trim();
    }
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}
