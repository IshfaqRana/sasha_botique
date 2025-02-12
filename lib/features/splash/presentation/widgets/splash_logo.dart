import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sasha_botique/core/extensions/get_size_extensions.dart';

class SplashLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
