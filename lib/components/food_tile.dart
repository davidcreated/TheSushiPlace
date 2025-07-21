// lib/components/food_tile.dart - MODIFIED VERSION

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thesushi_place/models/food.dart';
import 'package:thesushi_place/themes/colors.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;

  const FoodTile({
    Key? key,
    required this.food,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // The container itself defines the overall size for each tile
        width: 200, // This width will be passed down to its children
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 20), // Spacing between tiles
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use this if you want space distributed vertically
          children: [
            // Food image - THE FIX IS HERE!
            // Ensure the image has explicit dimensions within the tile's context.
            // Since the parent Container has a width, we can use alignment to center it.
            Align( // Align the image within the available width of the Column
              alignment: Alignment.center,
              child: SizedBox(
                width: 140, // Give the image a specific width
                height: 100, // Give the image a specific height
                child: Image.asset(
                  food.imagePath,
                  fit: BoxFit.contain, // Ensures the image scales down to fit
                ),
              ),
            ),
            const SizedBox(height: 12), // Space after image

            // Food name
            Text(
              food.name,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 18,
                color: Colors.white,
              ),
              // Consider maxLines if name can be long to prevent overflow
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Price + rating
            // This Row also benefits from being constrained to the tile's width
            SizedBox(
              width: double.infinity, // Take all available width of the parent Column
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Text(
                    '\$${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.greenAccent, // Using greenAccent for price as an example
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 16,
                      ),
                      Text(
                        food.rating,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}