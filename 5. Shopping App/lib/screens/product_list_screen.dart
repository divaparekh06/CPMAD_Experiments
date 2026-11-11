import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  // Dummy product list grouped by categories
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Laptop',
      price: 45000.0,
      category: 'Electronics',
      description: 'High performance laptop for coding and tasks.',
    ),
    Product(
      id: '2',
      name: 'Smartphone',
      price: 20000.0,
      category: 'Electronics',
      description: 'Latest smartphone with great battery life.',
    ),
    Product(
      id: '3',
      name: 'T-Shirt',
      price: 799.0,
      category: 'Clothing',
      description: 'Comfortable cotton casual wear t-shirt.',
    ),
    Product(
      id: '4',
      name: 'Jeans',
      price: 1499.0,
      category: 'Clothing',
      description: 'Classic fit blue denim jeans.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Catalog'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Electronics'),
              Tab(text: 'Clothing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Electronics Category List
            _buildProductListView(context, 'Electronics'),
            // Clothing Category List
            _buildProductListView(context, 'Clothing'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListView(BuildContext context, String category) {
    final categoryProducts = _allProducts
        .where((p) => p.category == category)
        .toList();

    return ListView.builder(
      itemCount: categoryProducts.length,
      itemBuilder: (context, index) {
        final product = categoryProducts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('₹${product.price}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            // Gesture / Tap interaction to open details and pass route arguments
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: product, // Passing product object as route argument
              );
            },
          ),
        );
      },
    );
  }
}
