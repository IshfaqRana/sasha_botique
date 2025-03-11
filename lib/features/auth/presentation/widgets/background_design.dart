import 'package:flutter/material.dart';

import '../../../theme/presentation/theme/theme_helper.dart';

class BackgroundDesign extends StatelessWidget {
  final double width;
  final double height;
  const BackgroundDesign({super.key, this.height = 434,this.width = 414});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Colors.black,
                lightWhiteColor,
              ]),
            ),
          ),
        ),
        Positioned(
          right: 40,
            top: 100,
            child: SizedBox(
                height: 250,
                width: 180,
                child: Image.asset(
                  "assets/images/design.png",
                ))),
        Positioned(
            right: 30,
            top: 40,
            child: SizedBox(
                width: 120,
                height: 380,
                child: Image.asset(
                  "assets/images/login_girl.png",
                ))),
      ],
    );
  }
}
