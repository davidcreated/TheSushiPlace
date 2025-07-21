// lib/models/food.dart

import 'package:flutter/material.dart'; // Often included, though not strictly needed for this class

class Food {
  String name;
  double price;
  String imagePath;
  String description;
  String rating;

  Food({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.rating,
  });

  // IMPORTANT: Override == and hashCode for proper comparison in collections.
  // This tells Dart that two Food objects are "equal" if their identifying
  // properties (name, price, imagePath) are the same, even if they are different instances.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If they are the very same instance, they are equal.

    return other is Food && // Check if 'other' is also a Food object.
           name == other.name && // Compare names
           price == other.price && // Compare prices
           imagePath == other.imagePath; // Compare image paths
  }

  @override
  int get hashCode {
    // Combine the hash codes of the properties used in the == operator.
    // This method is crucial for efficient lookups in Maps and Sets.
    return Object.hash(name, price, imagePath);
  }
}