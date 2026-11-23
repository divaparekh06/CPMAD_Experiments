import 'package:flutter/material.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'state/shop_store.dart';

void main() {
  runApp(const ApiShoppingCartApp());
}

class ApiShoppingCartApp extends StatefulWidget {
  const ApiShoppingCartApp({super.key});

  @override
  State<ApiShoppingCartApp> createState() => _ApiShoppingCartAppState();
}

class _ApiShoppingCartAppState extends State<ApiShoppingCartApp> {
  final ShopStore _store = ShopStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreScope(
      store: _store,
      child: MaterialApp(
        title: 'API-Driven Shopping Cart',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const CatalogScreen(),
          '/cart': (context) => const CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
