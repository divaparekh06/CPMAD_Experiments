import 'package:flutter/material.dart';
import 'screens/quote_screens.dart';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const QuoteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
