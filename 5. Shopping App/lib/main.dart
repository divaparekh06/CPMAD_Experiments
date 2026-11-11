import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Application',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // Define initial route
      initialRoute: '/',
      // Define named routes mapping
      routes: {
        '/': (context) => const HomeScreen(),
        '/products': (context) => ProductListScreen(),
        '/details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
