import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cartController;
  late Animation<double> _cartAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller for cart item entrance
    _cartController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _cartAnimation = CurvedAnimation(
      parent: _cartController,
      curve: Curves.elasticOut,
    );
    _cartController.forward();
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve product passed from details screen
    final product = ModalRoute.of(context)!.settings.arguments as Product?;

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: product == null
          ? const Center(child: Text('Your cart is empty!'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Animated Cart Item entrance
                  ScaleTransition(
                    scale: _cartAnimation,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.shopping_bag,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(product.category),
                        trailing: Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order Placed Successfully!'),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
