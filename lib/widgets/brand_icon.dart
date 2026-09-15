import 'package:flutter/material.dart';

/// The app's brand mark (glass pin / neon checkmark), bundled as
/// assets/brand_icon.png — same source image used for the web favicon.
class BrandIcon extends StatelessWidget {
  const BrandIcon({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.18),
      child: Image.asset('assets/brand_icon.png', width: size, height: size, fit: BoxFit.cover),
    );
  }
}
