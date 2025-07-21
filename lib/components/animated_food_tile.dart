import 'package:flutter/material.dart';
import 'package:thesushi_place/components/food_tile.dart'; // Import your original FoodTile
import 'package:thesushi_place/models/food.dart'; // Import your Food model

class AnimatedFoodTile extends StatefulWidget {
  final Food food;
  final VoidCallback onTap;
  final int index; // To allow for staggered animation

  const AnimatedFoodTile({
    Key? key,
    required this.food,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedFoodTile> createState() => _AnimatedFoodTileState();
}

class _AnimatedFoodTileState extends State<AnimatedFoodTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Adjust duration
    );

    // Stagger animation based on index
    final int delayMilliseconds = 100 * widget.index; // Each item delays by 100ms
    final int totalDuration = _animationController.duration!.inMilliseconds + delayMilliseconds;

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Starts slightly below its final position
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        delayMilliseconds / totalDuration, // Start after delay
        1.0, // End at controller's end
        curve: Curves.easeOutCubic,
      ),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        delayMilliseconds / totalDuration,
        1.0,
        curve: Curves.easeOut,
      ),
    ));

    // Play the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0), // Padding between horizontal items
          child: FoodTile(
            food: widget.food,
            onTap: widget.onTap,
            key: widget.key, // Ensure key is passed through
          ),
        ),
      ),
    );
  }
}