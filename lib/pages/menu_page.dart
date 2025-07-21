// lib/pages/menu_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thesushi_place/components/animated_food_tile.dart';
import 'package:thesushi_place/components/animated_recommended_item_tile.dart';
import 'package:thesushi_place/components/button.dart';
import 'package:thesushi_place/models/food.dart';
import 'package:thesushi_place/pages/food_details_page.dart';
import 'package:thesushi_place/themes/colors.dart';
import 'dart:ui'; // Make sure this import is present for ImageFilter
import 'package:provider/provider.dart';
import 'package:thesushi_place/models/shop.dart';
import 'package:thesushi_place/pages/cart_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

// Ensure your State class extends TickerProviderStateMixin for vsync
class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _promoController;
  late Animation<Offset> _promoOffsetAnimation;
  late Animation<double> _promoFadeAnimation;

  late AnimationController _searchController;
  late Animation<Offset> _searchOffsetAnimation;
  late Animation<double> _searchFadeAnimation;

  // Recommended Items List (Assuming this is still managed here, not in Shop)
  List<Map<String, dynamic>> recommendedItems = [
    {
      'name': 'Shrimp Tempura',
      'price': '\$15.50',
      'rating': '4.7',
      'image': 'assets/images/kind2.png',
      'isFavorite': false,
    },
    {
      'name': 'Spicy Tuna Roll',
      'price': '\$17.00',
      'rating': '4.9',
      'image': 'assets/images/kind4.png',
      'isFavorite': true,
    },
    {
      'name': 'Avocado Sushi',
      'price': '\$12.00',
      'rating': '4.5',
      'image': 'assets/images/unagiroll.png',
      'isFavorite': false,
    },
    {
      'name': 'Dragon Roll',
      'price': '\$25.00',
      'rating': '4.8',
      'image': 'assets/images/kind1.png',
      'isFavorite': true,
    },
    {
      'name': 'Philadelphia Roll',
      'price': '\$16.50',
      'rating': '4.6',
      'image': 'assets/images/kind.png',
      'isFavorite': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize _promoController and its animations
    _promoController = AnimationController(
      vsync: this, // 'this' refers to the TickerProviderStateMixin
      duration: const Duration(milliseconds: 800),
    );
    _promoOffsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Starts off-screen to the left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _promoController,
      curve: Curves.easeOutCubic, // A smooth accelerating/decelerating curve
    ));
    _promoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _promoController,
      curve: Curves.easeOut,
    ));

    // Initialize _searchController and its animations (slightly delayed)
    _searchController = AnimationController(
      vsync: this, // 'this' refers to the TickerProviderStateMixin
      duration: const Duration(milliseconds: 800),
    );
    _searchOffsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Starts off-screen to the right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeOutCubic,
    ));
    _searchFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeOut,
    ));

    // Start animations after the page is built
    Future.delayed(const Duration(milliseconds: 200), () {
      _promoController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        // Stagger search bar animation
        _searchController.forward();
      });
    });
  }

  @override
  void dispose() {
    // ALWAYS dispose your AnimationControllers when the widget is removed
    _promoController.dispose();
    _searchController.dispose();
    super.dispose(); // Always call super.dispose() last
  }

  void toggleFavorite(int index) {
    setState(() {
      recommendedItems[index]['isFavorite'] = !recommendedItems[index]['isFavorite'];
    });
  }

  void navigateToFoodDetails(Food food) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FoodDetailsPage(food: food),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get foodMenu from Shop provider
    final shop = Provider.of<Shop>(context, listen: false);
    final List<Food> foodMenu = shop.foodMenu; // Get the foodMenu from the Shop

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9), // Dark background for the page
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white, size: 30), // Menu icon
        actions: [
          // Glassmorphism Cart Icon Button
          Padding(
            padding: const EdgeInsets.only(right: 10.0), // Adjusted padding
            child: GestureDetector( // Makes the entire glass container tappable
              onTap: () {
                Navigator.pushNamed(context, '/cartpage'); // Navigate to cart page
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Rounded corners for glass effect
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Blur effect
                  child: Container(
                    padding: const EdgeInsets.all(8), // Padding inside the glass effect
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15), // Semi-transparent background
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2), // Subtle border
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white, size: 30), // The cart icon
                  ),
                ),
              ),
            ),
          ),
          // User profile avatar
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: primaryColor,
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/george.png"),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Banner with Glassmorphism Effect and Animations
            SlideTransition(
              position: _promoOffsetAnimation,
              child: FadeTransition(
                opacity: _promoFadeAnimation,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Get 20% off",
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Button(
                                  text: "Redeem",
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Promo code applied!")),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/images/unagiroll.png',
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar with Glassmorphism Effect and Animations
            SlideTransition(
              position: _searchOffsetAnimation,
              child: FadeTransition(
                opacity: _searchFadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search for sushi, rolls, etc.",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.search, color: primaryColor),
                            suffixIcon:
                                Icon(Icons.filter_alt_outlined, color: primaryColor),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Food Menu Items Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Food Menu",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Food Tiles Categories - Horizontal List
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foodMenu.length,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                itemBuilder: (context, index) {
                  return AnimatedFoodTile(
                    food: foodMenu[index], // Pass the Food object from the Shop's menu
                    index: index,
                    onTap: () {
                      navigateToFoodDetails(foodMenu[index]); // Pass the same Food object
                    },
                    key: ValueKey(foodMenu[index].name + index.toString()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Recommended Items Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Recommended for you",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Recommended Items - Vertical List of containers
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
              shrinkWrap: true, // Takes only as much space as its children
              scrollDirection: Axis.vertical,
              itemCount: recommendedItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              itemBuilder: (context, index) {
                return AnimatedRecommendedItemTile(
                  itemName: recommendedItems[index]['name'],
                  itemPrice: recommendedItems[index]['price'],
                  itemRating: recommendedItems[index]['rating'],
                  imagePath: recommendedItems[index]['image'],
                  isFavorite: recommendedItems[index]['isFavorite'],
                  onFavoriteTap: () => toggleFavorite(index),
                  index: index,
                  key: ValueKey(recommendedItems[index]['name'] + index.toString()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}