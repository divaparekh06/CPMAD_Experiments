import 'package:flutter/material.dart';
import '../state/shop_store.dart';
import '../widgets/product_card.dart';

class StoreScope extends InheritedNotifier<ShopStore> {
  const StoreScope({super.key, required ShopStore store, required super.child})
    : super(notifier: store);

  static ShopStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StoreScope>();
    assert(scope != null, 'No StoreScope found in widget tree.');
    return scope!.notifier!;
  }
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final store = StoreScope.of(context);
      if (store.products.isEmpty &&
          !store.isLoading &&
          store.errorMessage == null) {
        store.loadProducts();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final products = store.filteredProducts;
    final totalQty = store.totalCartQuantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeStore Catalog'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              tooltip: 'Open Cart',
              onPressed: () => Navigator.pushNamed(context, '/cart'),
              icon: Badge(
                isLabelVisible: totalQty > 0,
                label: Text('$totalQty'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Category Filter Chips
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: TextField(
              controller: _searchController,
              onChanged: store.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search products or categories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: store.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          store.updateSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          if (store.categories.length > 1)
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: store.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = store.categories[index];
                  final isSelected = store.selectedCategory == category;
                  final label =
                      category[0].toUpperCase() + category.substring(1);
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => store.selectCategory(category),
                  );
                },
              ),
            ),

          const SizedBox(height: 6),

          // API States: Loading, Error, Empty Filter, or Product List
          Expanded(child: _buildBody(context, store, products)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ShopStore store, List products) {
    if (store.isLoading && store.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text('Loading products from store API...'),
          ],
        ),
      );
    }

    if (store.errorMessage != null && store.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 44,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to Load Catalog',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    store.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: store.loadProducts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 10),
            const Text('No matching products found.'),
            if (store.searchQuery.isNotEmpty ||
                store.selectedCategory != 'All') ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  store.updateSearchQuery('');
                  store.selectCategory('All');
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: store.loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ProductCard(
              product: product,
              quantityInCart: store.quantityInCart(product.id),
              onAdd: () => store.addToCart(product),
              onIncrement: () => store.incrementQuantity(product.id),
              onDecrement: () => store.decrementQuantity(product.id),
            ),
          );
        },
      ),
    );
  }
}
