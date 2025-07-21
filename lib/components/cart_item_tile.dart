// lib/components/cart_item_tile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thesushi_place/models/food.dart';
import 'package:thesushi_place/themes/colors.dart'; // Assuming you have your custom colors
import 'dart:ui'; // For ImageFilter

class CartItemTile extends StatelessWidget {
  final Food food;
  final int quantity;
  final VoidCallback onRemove; // Callback to remove item

  const CartItemTile({
    Key? key,
    required this.food,
    required this.quantity,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Glassmorphism
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // Semi-transparent background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Food Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    food.imagePath,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),

                // Food Name and Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${food.price.toStringAsFixed(2)} x $quantity', // Show price per item and quantity
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),

                // Remove Button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[300]),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}