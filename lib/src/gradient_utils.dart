import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// Utility functions for working with gradients
class GradientUtils {
  /// Creates a gradient from a single color with varying opacity
  static GradientConfig fromColor({
    required Color color,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
    double startOpacity = 1.0,
    double endOpacity = 0.0,
  }) {
    return GradientConfig(
      colors: [
        color.withOpacity(startOpacity),
        color.withOpacity(endOpacity),
      ],
      type: type,
      direction: direction,
    );
  }

  /// Creates a gradient by mixing two colors
  static GradientConfig mix({
    required Color color1,
    required Color color2,
    int steps = 5,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
  }) {
    assert(steps >= 2, 'At least 2 steps are required for mixing colors');
    
    final List<Color> colors = [];
    
    for (int i = 0; i < steps; i++) {
      final double ratio = i / (steps - 1);
      colors.add(Color.lerp(color1, color2, ratio)!);
    }
    
    return GradientConfig(
      colors: colors,
      type: type,
      direction: direction,
    );
  }

  /// Creates a rainbow gradient with custom intensity and saturation
  static GradientConfig rainbow({
    double saturation = 1.0,
    double lightness = 0.5,
    int steps = 7,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
  }) {
    final List<Color> colors = [];
    
    for (int i = 0; i < steps; i++) {
      final double hue = (i / steps) * 360;
      colors.add(HSLColor.fromAHSL(1, hue, saturation, lightness).toColor());
    }
    
    // Add the first color again to create a smooth loop if needed
    colors.add(colors.first);
    
    return GradientConfig(
      colors: colors,
      type: type,
      direction: direction,
    );
  }

  /// Creates a gradient from a palette of colors
  static GradientConfig fromPalette({
    required List<Color> palette,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
    bool closeGradient = false,
  }) {
    assert(palette.length >= 2, 'At least 2 colors are required for a gradient');
    
    final colors = closeGradient ? [...palette, palette.first] : palette;
    
    return GradientConfig(
      colors: colors,
      type: type,
      direction: direction,
    );
  }
}