import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Import for ImageFilter
import 'package:thesushi_place/themes/colors.dart'; // Import primaryColor

class RecommendedItemTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final String itemRating; // Added rating property
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const RecommendedItemTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.itemRating, // Make rating required
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect( // Removed horizontal padding here as it's now in MenuPage ListView.builder's item padding
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          // Removed fixed width for vertical list display
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),

              // Text details (name, price, and rating)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemName,
                      style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 18), // Star icon with primaryColor
                        const SizedBox(width: 5),
                        Text(
                          itemRating,
                          style: TextStyle(fontSize: 15, color: Colors.grey[200]), // Rating text color
                        ),
                        const SizedBox(width: 10), // Spacing between rating and price
                        Text(
                          itemPrice,
                          style: TextStyle(fontSize: 15, color: Colors.greenAccent[400], fontWeight: FontWeight.bold), // Price text color
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Favorite Icon
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.white.withOpacity(0.7),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}