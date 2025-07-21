// lib/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesushi_place/components/button.dart'; // Assuming you have a custom Button widget
import 'package:thesushi_place/models/shop.dart';
import 'package:thesushi_place/themes/colors.dart'; // For color theme
import 'package:google_fonts/google_fonts.dart';
import 'package:thesushi_place/models/food.dart';
import 'dart:ui'; // <--- NEW: Import for ImageFilter

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Method for "Pay Now" logic (currently a placeholder)
  void payNow(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800], // Slightly darker for AlertDialog
        title: const Text(
          "Proceed to Payment?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to finalize your order?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              // In a real app, process payment here.
              // For now, clear the cart and navigate back.
              Provider.of<Shop>(context, listen: false).clearCart();
              Navigator.pop(context); // Close the dialog
              // You might want to navigate to a success page or back to the menu
              Navigator.pushNamedAndRemoveUntil(context, '/intropage', (route) => false);
            },
            child: Text("Yes, Pay", style: TextStyle(color: accentColor)), // Use accentColor for action
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Solid black background for iOS depth effect
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fully transparent
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true, // Center title for iOS look
        title: Text(
          "My Cart",
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // iOS back button
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Clear cart button (redesign with glassmorphism)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Slightly rounded corners
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Stronger blur
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Translucent white
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.15)), // Subtle border
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent), // Red accent for delete
                    onPressed: () {
                      Provider.of<Shop>(context, listen: false).clearCart();
                    },
                    tooltip: 'Clear Cart',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<Shop>(
        builder: (context, shop, child) {
          final cartItems = shop.cartItems;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[700]),
                  const SizedBox(height: 24),
                  Text(
                    "Your cart is empty!",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Add some delicious sushi to get started.",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Overall rounded container for the list
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08), // Slightly more transparent for the list background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          itemBuilder: (context, index) {
                            final itemEntry = cartItems[index];
                            final Food food = itemEntry.key;
                            final int quantity = itemEntry.value;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // Rounded corners for each item tile
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05), // Even more transparent for individual items
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(food.imagePath, height: 70, width: 70, fit: BoxFit.cover),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                food.name,
                                                style: GoogleFonts.dmSerifDisplay(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${food.price.toStringAsFixed(2)} per item',
                                                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            // Quantity controls
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove, color: Colors.grey[300], size: 20),
                                                    onPressed: () => shop.removeFromCart(food),
                                                    padding: EdgeInsets.zero,
                                                    constraints: BoxConstraints(),
                                                  ),
                                                  Text(
                                                    '$quantity',
                                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add, color: Colors.grey[300], size: 20),
                                                    onPressed: () => shop.addToCart(food, 1), // Add one more
                                                    padding: EdgeInsets.zero,
                                                    constraints: BoxConstraints(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Total for this item
                                            Text(
                                              '\$${(food.price * quantity).toStringAsFixed(2)}',
                                              style: GoogleFonts.dmSerifDisplay(color: accentColor, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Total and Pay button (bottom glassmorphism container)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0), // More blur for bottom sheet
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12), // More opaque than list items
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Price:",
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${shop.calculateTotal().toStringAsFixed(2)}",
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 24,
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Button(
                          text: "Pay Now", // Text for button
                          onTap: () => payNow(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}