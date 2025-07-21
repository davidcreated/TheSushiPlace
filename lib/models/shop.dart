// lib/models/shop.dart
import 'package:flutter/material.dart'; // Import for ChangeNotifier
import 'package:thesushi_place/models/food.dart'; // Ensure Food model is imported

class Shop extends ChangeNotifier {
  // Food menu (unchanged, still the master list of available foods)
  final List<Food> _foodMenu = [
    Food(
      name: "Salmon Sushi",
      rating: "4.9",
      price: 21.0,
      imagePath: "assets/images/unagiroll.png",
      description: "Fresh, buttery salmon draped over seasoned rice.",
    ),
    Food(
      name: "Tuna Sushi",
      rating: "4.8",
      price: 19.0,
      imagePath: "assets/images/kind.png",
      description: "Delicate and lean tuna sushi, a healthy and delicious option.",
    ),
    Food(
      name: "Unagi Sushi",
      rating: "4.7",
      price: 22.0,
      imagePath: "assets/images/kind1.png",
      description: "Grilled freshwater eel with a sweet unagi sauce.",
    ),
    Food(
      name: "Maki Sushi",
      rating: "4.6",
      price: 18.0,
      imagePath: "assets/images/kind2.png",
      description: "A selection of traditional rolled sushi with fresh ingredients.",
    ),
    Food(
      name: "California Roll",
      rating: "4.5",
      price: 20.0,
      imagePath: "assets/images/kind4.png",
      description: "The popular roll with imitation crab, avocado, and cucumber.",
    ),
    Food(
      name: "Sushi Platter",
      price: 25.99,
      imagePath: "assets/images/sushi_platter.png",
      description: "A delightful assortment of fresh sushi rolls, perfect for sharing.",
      rating: "4.7",
    ),
    Food(
      name: "Ramen Bowl",
      price: 15.99,
      imagePath: "assets/images/ramen_bowl.png",
      description: "A hearty bowl of traditional Japanese ramen with rich broth and toppings.",
      rating: "4.6",
    ),
  ];

  // User cart - now a Map to store Food and its quantity
  // This map uses the Food object itself as the key.
  final Map<Food, int> _cartItems = {}; // Food item -> Quantity

  // Getter for food menu (returns an unmodifiable list to prevent external modification)
  List<Food> get foodMenu => List.unmodifiable(_foodMenu);

  // Getter for user cart (returns a list of MapEntry for easy iteration in UI)
  List<MapEntry<Food, int>> get cartItems => _cartItems.entries.toList();

  // Add item to cart method
  void addToCart(Food foodItem, int quantity) {
    // If foodItem already exists in the map, update its quantity.
    // Otherwise, add it with the initial quantity.
    _cartItems.update(
      foodItem,
      (existingQuantity) => existingQuantity + quantity, // If item exists, add quantity
      ifAbsent: () => quantity, // If item doesn't exist, add it with initial quantity
    );
    notifyListeners(); // Notify all listening widgets that the cart has changed
  }

  // Remove item from cart method (decrements quantity or removes entirely)
  void removeFromCart(Food foodItem) {
    if (_cartItems.containsKey(foodItem)) {
      _cartItems.update(foodItem, (existingQuantity) {
        if (existingQuantity > 1) {
          return existingQuantity - 1; // Decrement quantity
        } else {
          return 0; // If quantity becomes 0, mark for removal
        }
      });
      // Remove any items from the map whose quantity has dropped to 0
      _cartItems.removeWhere((key, value) => value == 0);
      notifyListeners(); // Notify all listening widgets
    }
  }

  // Calculate total price of items in the cart
  double calculateTotal() {
    double total = 0.0;
    _cartItems.forEach((food, quantity) {
      total += food.price * quantity;
    });
    return total;
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners(); // Notify all listening widgets
  }
}