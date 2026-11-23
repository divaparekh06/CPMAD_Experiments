import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/store_api_service.dart';

class ShopStore extends ChangeNotifier {
  final StoreApiService _apiService;

  ShopStore({StoreApiService? apiService})
    : _apiService = apiService ?? StoreApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Keyed by product.id for O(1) lookup and quantity updates
  final Map<int, CartItem> _cartItems = {};

  // --- Read-only getters ---
  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<CartItem> get cartItems => _cartItems.values.toList(growable: false);

  List<String> get categories {
    final unique = <String>{};
    for (final product in _products) {
      if (product.category.isNotEmpty) {
        unique.add(product.category);
      }
    }
    final sorted = unique.toList()..sort();
    return ['All', ...sorted];
  }

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesQuery =
          query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // --- Derived cart metrics ---
  int get totalCartQuantity {
    int count = 0;
    for (final item in _cartItems.values) {
      count += item.quantity;
    }
    return count;
  }

  double get subtotal {
    double sum = 0.0;
    for (final item in _cartItems.values) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double get gstAmount => subtotal * 0.18;

  double get totalPayable => subtotal + gstAmount;

  int quantityInCart(int productId) => _cartItems[productId]?.quantity ?? 0;

  // --- Actions ---
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
      if (!_products.any((p) => p.category == _selectedCategory)) {
        _selectedCategory = 'All';
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart(Product product) {
    final existing = _cartItems[product.id];
    if (existing != null) {
      existing.quantity += 1;
    } else {
      _cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final existing = _cartItems[productId];
    if (existing == null) return;
    existing.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    final existing = _cartItems[productId];
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity -= 1;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    if (_cartItems.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clearCart() {
    if (_cartItems.isEmpty) return;
    _cartItems.clear();
    notifyListeners();
  }
}
