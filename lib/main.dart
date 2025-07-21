// main.dart
import 'package:flutter/material.dart';
import 'package:thesushi_place/pages/intropage.dart';
import 'package:thesushi_place/pages/menu_page.dart';
import 'package:provider/provider.dart';
import 'package:thesushi_place/models/shop.dart';
import 'package:thesushi_place/pages/cart_page.dart'; // Import the new CartPage

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      routes: {
        "/intropage": (context) => const IntroPage(),
        "/menupage": (context) => const MenuPage(),
        "/cartpage": (context) => const CartPage(), // <--- ADD THIS ROUTE
      },
    );
  }
}