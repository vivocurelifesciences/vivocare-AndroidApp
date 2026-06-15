import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';

/// Drag-and-drop arrangement of products for the rep's presentations.
///
/// Two modes:
///  - With [selectedIds]: arranges ONLY those products (the presentation
///    being prepared) and pops the new id order back to the caller.
///  - Without: arranges the full catalog as a device-local preference
///    (saved instantly, never synced) — fully offline either way.
class ProductReorderScreen extends StatefulWidget {
  const ProductReorderScreen({super.key, this.selectedIds});

  final List<String>? selectedIds;

  @override
  State<ProductReorderScreen> createState() => _ProductReorderScreenState();
}

class _ProductReorderScreenState extends State<ProductReorderScreen> {
  List<Product> _products = <Product>[];
  final Map<String, String> _imagePaths = <String, String>{};
  bool _loading = true;
  bool _dirty = false;

  bool get _isSubset => widget.selectedIds?.isNotEmpty ?? false;

  List<String> get _currentOrder =>
      _products.map((Product p) => p.id).toList(growable: false);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<Product> products;
    if (_isSubset) {
      // Only the products picked for this presentation, in the caller's order.
      final List<String> ids = widget.selectedIds!;
      final Map<String, Product> byId = <String, Product>{
        for (final Product p in await AppServices.products.byIds(ids)) p.id: p,
      };
      products = ids
          .map((String id) => byId[id])
          .whereType<Product>()
          .toList(growable: false);
    } else {
      products = await AppServices.products.allProducts();
    }
    for (final Product product in products) {
      final String? path = await AppServices.products.localImagePath(
        product.id,
      );
      if (path != null) {
        _imagePaths[product.id] = path;
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _products = List<Product>.of(products);
      _loading = false;
    });
  }

  Future<void> _persist() async {
    // Subset order is returned to the caller on pop, not saved globally.
    if (_isSubset) {
      return;
    }
    await AppServices.products.saveLocalOrder(_currentOrder);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Product moved = _products.removeAt(oldIndex);
      _products.insert(newIndex, moved);
      _dirty = true;
    });
    _persist();
  }

  void _shuffle() {
    if (_products.length < 2) {
      return;
    }
    setState(() {
      _products.shuffle(math.Random());
      _dirty = true;
    });
    _persist();
  }

  Future<void> _resetOrder() async {
    await AppServices.products.resetLocalOrder();
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = true;
      _dirty = false;
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopScope<Object?>(
      // Subset mode: intercept the pop so the arranged order travels back
      // to the presentation sheet.
      canPop: !_isSubset,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(_currentOrder);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arrange Presentation'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Shuffle order',
              onPressed: _shuffle,
              icon: const Icon(Icons.shuffle_rounded, size: 20),
            ),
            if (!_isSubset)
              TextButton.icon(
                onPressed: _resetOrder,
                icon: const Icon(Icons.restart_alt, size: 18),
                label: const Text('Reset'),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: AppPageBackdrop(
          child: SafeArea(
            child: Center(
              // Tablet-friendly: keep the list a comfortable reading width.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                    ? Center(
                        child: Text(
                          'No products yet. Sync once to load products.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                            child: Text(
                              _isSubset
                                  ? 'Drag to set the order you will present '
                                        'these products in. Applies to this '
                                        'presentation only.'
                                  : 'Drag to set the order you present '
                                        'products to a doctor. Saved on this '
                                        'device instantly.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          if (_dirty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isSubset ? 'Order updated' : 'Order saved',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ReorderableListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: _products.length,
                              onReorder: _onReorder,
                              proxyDecorator:
                                  (
                                    Widget child,
                                    int index,
                                    Animation<double> animation,
                                  ) {
                                    return Material(
                                      color: Colors.transparent,
                                      elevation: 6,
                                      borderRadius: BorderRadius.circular(16),
                                      child: child,
                                    );
                                  },
                              itemBuilder: (BuildContext context, int index) {
                                final Product product = _products[index];
                                return _ProductReorderTile(
                                  key: ValueKey<String>(product.id),
                                  index: index,
                                  product: product,
                                  localImagePath: _imagePaths[product.id],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductReorderTile extends StatelessWidget {
  const _ProductReorderTile({
    super.key,
    required this.index,
    required this.product,
    required this.localImagePath,
  });

  final int index;
  final Product product;
  final String? localImagePath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(width: 52, height: 52, child: _productImage()),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((product.productCode ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.productCode!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.drag_handle, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage() {
    final String? path = localImagePath;
    if (path != null) {
      return Image.file(File(path), fit: BoxFit.cover);
    }
    final String? url = product.primaryImageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? trace) =>
            _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    color: AppColors.primaryBlue.withValues(alpha: 0.06),
    child: const Icon(Icons.medication_outlined, color: AppColors.primaryBlue),
  );
}
