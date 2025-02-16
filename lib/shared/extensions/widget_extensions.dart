import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension SvgExtension on Widget {
  /// Renders an SVG image from the provided asset path.
  Widget svgAsset(
      String assetPath, {
        double? width,
        double? height,
        Color? color,
        BoxFit fit = BoxFit.contain,
      }) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }

  /// Renders an SVG image from the provided network URL.
  Widget svgNetwork(
      String url, {
        double? width,
        double? height,
        Color? color,
        BoxFit fit = BoxFit.contain,
      }) {
    return SvgPicture.network(
      url,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}