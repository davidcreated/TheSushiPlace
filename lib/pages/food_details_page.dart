// lib/pages/food_details_page.dart

import 'package:flutter/material.dart';
import 'package:thesushi_place/models/food.dart'; // Import your Food model
import 'dart:ui'; // Import for ImageFilter
import 'package:thesushi_place/themes/colors.dart'; // Assuming you have this for primaryColor or similar
import 'package:provider/provider.dart'; // <--- ADDED: To use Provider for state management
import 'package:thesushi_place/models/shop.dart'; // <--- ADDED: To access your Shop model

class FoodDetailsPage extends StatefulWidget {
  final Food food;

  const FoodDetailsPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> with TickerProviderStateMixin {
  int quantity = 1; // State for the counter

  // Animation Controllers
  late AnimationController _headerController;
  late Animation<Offset> _headerOffsetAnimation;
  late Animation<double> _headerFadeAnimation;

  late AnimationController _detailsController;
  late Animation<Offset> _detailsOffsetAnimation;
  late Animation<double> _detailsFadeAnimation;

  late AnimationController _bottomSheetController;
  late Animation<Offset> _bottomSheetOffsetAnimation;
  late Animation<double> _bottomSheetFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Header Animations (Image, Name, Rating, Price)
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Starts slightly below its final position
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeIn,
    ));

    // Initialize Details Animations (Description)
    _detailsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _detailsOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // Starts slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _detailsController,
      curve: Curves.easeOutCubic,
    ));
    _detailsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _detailsController,
      curve: Curves.easeIn,
    ));

    // Initialize Bottom Sheet Animations (Quantity, Add to Cart)
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bottomSheetOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Starts off-screen from the bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeOutCubic,
    ));
    _bottomSheetFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeIn,
    ));

    // Start animations in a staggered fashion
    Future.delayed(const Duration(milliseconds: 100), () {
      _headerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _detailsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _bottomSheetController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _detailsController.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  // Method to decrement quantity
  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  // Method to increment quantity
  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  // >>>>>> CRITICAL CORRECTION HERE <<<<<<
  // This method now correctly adds the food item to the cart using the Shop provider.
  void addToCart() {
    // Access the Shop provider using Provider.of.
    // 'listen: false' is used because this widget only needs to *modify* the Shop's state,
    // not rebuild itself when the Shop's state changes.
    final shop = Provider.of<Shop>(context, listen: false);

    // Call the addToCart method from your Shop model, passing the food item and current quantity.
    shop.addToCart(widget.food, quantity);

    // Show a success message as a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${quantity} x ${widget.food.name} to cart!',
          style: TextStyle(color: Colors.white), // Ensure snackbar text is visible
        ),
        backgroundColor: Colors.green, // Green background for success
        duration: const Duration(seconds: 2),
      ),
    );

    // Optional: After adding to cart, you might want to:
    // 1. Pop the page (go back to the menu):
    // Navigator.pop(context);
    // 2. Navigate directly to the cart page:
    // Navigator.pushNamed(context, '/cartpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9), // Slightly transparent background for overall depth
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Animated Image
                SlideTransition(
                  position: _headerOffsetAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Rounded corners for image
                        child: Image.asset(
                          widget.food.imagePath,
                          height: 300,
                          width: double.infinity, // Take full width
                          fit: BoxFit.cover, // Ensures image fills the space without distortion
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Food Name
                SlideTransition(
                  position: _headerOffsetAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 5.0),
                      child: Text(
                        widget.food.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32, // Slightly larger for emphasis
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Rating
                SlideTransition(
                  position: _headerOffsetAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                      child: Text(
                        'Rating: ${widget.food.rating} ⭐',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Price
                SlideTransition(
                  position: _headerOffsetAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                      child: Text(
                        'Price: \$${widget.food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 24, // Larger for price
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Description with Glassmorphism
                SlideTransition(
                  position: _detailsOffsetAnimation,
                  child: FadeTransition(
                    opacity: _detailsFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1), // Semi-transparent white
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2), // Subtle border
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              'A delicious and fresh piece of ${widget.food.name.toLowerCase()}. Hand-rolled by our expert chefs, '
                              'perfect for a delightful culinary experience. Enjoy it with a side of soy sauce and wasabi.',
                              style: TextStyle(
                                color: Colors.grey[200], // Lighter text for glassmorphism
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated Price + Quantity + Add to Cart Section (Bottom Sheet like)
          SlideTransition(
            position: _bottomSheetOffsetAnimation,
            child: FadeTransition(
              opacity: _bottomSheetFadeAnimation,
              child: ClipRRect(
                // Apply ClipRRect to enable BackdropFilter for rounded corners
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Stronger blur for bottom sheet
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4), // Darker, more opaque glassmorphism
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Make column only take required space
                      children: [
                        // Quantity selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Row(
                              children: [
                                // Minus button
                                InkWell( // Use InkWell for better tap feedback
                                  onTap: decrementQuantity,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.remove, color: Colors.white, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Quantity count
                                AnimatedSwitcher( // Smooth transition for quantity changes
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    '$quantity', // Display actual quantity
                                    key: ValueKey<int>(quantity), // Key for AnimatedSwitcher
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Plus button
                                InkWell( // Use InkWell for better tap feedback
                                  onTap: incrementQuantity,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25), // Increased spacing
                        // Add to cart button
                        GestureDetector( // Use GestureDetector for custom tap
                          onTap: addToCart, // This will now correctly call the logic above
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent[400], // Brighter green for button
                              borderRadius: BorderRadius.circular(15), // Slightly larger border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Add to Cart (\$${(widget.food.price * quantity).toStringAsFixed(2)})", // Show total price
                                style: const TextStyle(
                                  color: Colors.black87, // Darker text for contrast
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}