import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sashaBg.jpeg'),
          fit: BoxFit.cover, // Full screen coverage
          alignment: Alignment.center,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.1), // Optional: subtle overlay
      ),
    );
  }
}
