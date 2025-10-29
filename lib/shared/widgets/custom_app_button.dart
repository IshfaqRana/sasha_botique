import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.width,
    this.height,
    this.textStyle,
    this.borderRadius = 25,
    this.border,
    this.padding,
  }) : super(key: key);

  // Factory constructor for dialog buttons
  factory CustomButton.dialog({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      borderRadius: 8,
      height: 40,
      width: null, // Let it size based on content
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = textStyle ??
        context.headlineLarge?.copyWith(
          fontSize: 12,
          color: foregroundColor ?? Colors.white,
        );

    return GestureDetector(
      onTap: (isLoading || onPressed == null) ? null : onPressed,
      child: Container(
        width: width,
        height: height ?? 50,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: border ?? Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor ?? Colors.black,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: foregroundColor ?? Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: defaultTextStyle,
                ),
        ),
      ),
    );
  }
}
