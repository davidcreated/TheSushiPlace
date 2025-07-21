import 'package:flutter/material.dart';
import 'dart:ui'; // Import for ImageFilter

class Button extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const Button({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Wrap the entire button content with ClipRRect for rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40), // Match the Container's border radius
        // Apply the blur effect to the background visible through this widget
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Adjust blur strength as desired
          child: Container(
            // Move color into decoration for glass effect transparency
            decoration: BoxDecoration(
              // Original color with reduced opacity for the glass effect
              color: const Color.fromARGB(212, 135, 81, 71).withOpacity(0.4),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // Subtle white border
                width: 1.0,
              ),
              // You can add a subtle shadow here if you want, but it might interfere
              // with the "flat" glass look if not done carefully.
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 10,
              //     spreadRadius: 1,
              //     offset: Offset(0, 4),
              //   ),
              // ],
            ),
            // Preserve the original padding as requested
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Ensure the Row only takes minimal horizontal space
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}