import 'package:flutter/material.dart';

import '../../../theme/presentation/theme/theme_helper.dart';

class BackgroundDesign extends StatelessWidget {
  final double width;
  final double height;

  const BackgroundDesign({
    super.key,
    this.height = 434,
    this.width = 414,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final responsiveHeight = height > 0 ? height : screenHeight * 0.5;
    final responsiveWidth = width > 0 ? width : screenWidth;

    // Adjust image sizes based on screen size
    final isSmallScreen = screenWidth < 600;
    final designImageHeight = isSmallScreen ? 180.0 : 250.0;
    final designImageWidth = isSmallScreen ? 130.0 : 180.0;
    final loginGirlHeight = isSmallScreen ? 280.0 : 380.0;
    final loginGirlWidth = isSmallScreen ? 90.0 : 120.0;

    return Stack(
      children: [
        // Background gradient
        Positioned(
          child: Container(
            width: double.infinity,
            height: responsiveHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  lightWhiteColor,
                ],
              ),
            ),
          ),
        ),

        // Design image (right side)
        Positioned(
          right: isSmallScreen ? 20 : 40,
          top: isSmallScreen ? 60 : 100,
          child: SizedBox(
            height: designImageHeight,
            width: designImageWidth,
            child: Image.asset(
              "assets/images/design.png",
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Login girl image (top right)
        Positioned(
          right: isSmallScreen ? 15 : 30,
          top: isSmallScreen ? 25 : 40,
          child: SizedBox(
            width: loginGirlWidth,
            height: loginGirlHeight,
            child: Image.asset(
              "assets/images/login_girl.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
