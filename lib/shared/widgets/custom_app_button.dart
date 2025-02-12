import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double width;
  final double height;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black,width: 2),
          borderRadius: BorderRadius.circular(25),
          color: backgroundColor ?? Colors.black,
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            text,
            style: textStyle ?? context.headlineLarge?.copyWith(fontSize: 12,color:  Colors.white),

        ),
        ),
      ),
    );
  }
}
