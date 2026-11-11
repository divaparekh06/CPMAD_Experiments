import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Track selected index for AnimatedContainer hover/selection effect
  int _selectedIndex = -1;

  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 2499.0,
      category: 'Electronics',
      description:
          'Noise-cancelling over-ear wireless headphones with deep bass.',
      imageAsset: 'headphones',
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 3999.0,
      category: 'Electronics',
      description:
          'Fitness tracking smart watch with heart rate and sleep monitor.',
      imageAsset: 'watch',
    ),
    Product(
      id: '3',
      name: 'Running Shoes',
      price: 1799.0,
      category: 'Footwear',
      description: 'Lightweight breathable running shoes for daily workouts.',
      imageAsset: 'shoes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTapDown: (_) => setState(() => _selectedIndex = index),
            onTapUp: (_) {
              setState(() => _selectedIndex = -1);
              // Navigate to details with custom page transition
              Navigator.pushNamed(context, '/details', arguments: product);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.2 : 0.08),
                    blurRadius: isSelected ? 12 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
