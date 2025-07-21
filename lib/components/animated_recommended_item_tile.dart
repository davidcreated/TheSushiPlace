import 'package:flutter/material.dart';
import 'package:thesushi_place/components/recommend_item_tile.dart'; // Import your original RecommendedItemTile

class AnimatedRecommendedItemTile extends StatefulWidget {
  final String itemName;
  final String itemPrice;
  final String itemRating;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final int index; // For staggered animation

  const AnimatedRecommendedItemTile({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.itemRating,
    required this.imagePath,
    this.isFavorite = false,
    this.onFavoriteTap,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedRecommendedItemTile> createState() => _AnimatedRecommendedItemTileState();
}

class _AnimatedRecommendedItemTileState extends State<AnimatedRecommendedItemTile> with SingleTickerProviderStateMixin {
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
        delayMilliseconds / totalDuration,
        1.0,
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
          padding: const EdgeInsets.only(bottom: 10.0), // Padding between vertical items
          child: RecommendedItemTile(
            itemName: widget.itemName,
            itemPrice: widget.itemPrice,
            itemRating: widget.itemRating,
            imagePath: widget.imagePath,
            isFavorite: widget.isFavorite,
            onFavoriteTap: widget.onFavoriteTap,
            key: widget.key, // Ensure key is passed through
          ),
        ),
      ),
    );
  }
}