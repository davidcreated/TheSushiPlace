import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thesushi_place/components/button.dart';

import 'package:thesushi_place/pages/menu_page.dart'; // Make sure to import your MenuPage

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 60),

            // Shop name
            Text(
              "THE SUSHI PLACE",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 32,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(top: 12, left: 53),
              child: Image.asset(
                'assets/images/home.png',
                height: 250,
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20), // Add some space after the image

            // Main title and description
            Text(
              "THE TASTE OF JAPANESE CUISINE",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 44,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Feel the taste of Japan with our authentic sushi, delivered right to your door.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[200],
                height: 2,
              ),
            ),

            const SizedBox(height: 20),

            Button(
              text: "Get Started",
              onTap: () {
                // The current PageRouteBuilder with FadeTransition is already very smooth.
                // It's one of the most performant transition types.
                // Any perceived "lag" would likely be due to the complexity of the MenuPage
                // (e.g., multiple BackdropFilters) during its initial build/layout,
                // rather than the transition itself.

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MenuPage(), // The destination page
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Using a simple FadeTransition is generally the most performant.
                      // Adjust the curve if you want a different feel, but keep it simple.
                      const curve = Curves.easeOut; // or Curves.easeInOutCubic, Curves.fastOutSlowIn
                      var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

                      return FadeTransition(
                        opacity: animation.drive(tween),
                        child: child,
                      );
                    },
                    // Keep duration reasonable. Too long can feel slow. 500ms is a common sweet spot.
                    transitionDuration: Duration(milliseconds: 700),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}