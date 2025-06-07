import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Defines the type of gradient to use
enum GradientType {
  linear,
  radial,
  sweep,
}

/// Defines the direction for linear gradients
enum GradientDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  topLeftToBottomRight,
  topRightToBottomLeft,
  bottomLeftToTopRight,
  bottomRightToTopLeft,
}

/// Configuration class for gradients
class GradientConfig {
  /// Colors to use in the gradient
  final List<Color> colors;
  
  /// Optional stops for each color in the gradient
  final List<double>? stops;
  
  /// Type of gradient (linear, radial, sweep)
  final GradientType type;
  
  /// Direction for linear gradients
  final GradientDirection direction;
  
  /// Center point for radial and sweep gradients
  final Alignment center;
  
  /// Radius for radial gradients
  final double radius;
  
  /// Start angle for sweep gradients (in radians)
  final double startAngle;
  
  /// End angle for sweep gradients (in radians)
  final double endAngle;
  
  /// Creates a new gradient configuration
  const GradientConfig({
    required this.colors,
    this.stops,
    this.type = GradientType.linear,
    this.direction = GradientDirection.leftToRight,
    this.center = Alignment.center,
    this.radius = 0.5,
    this.startAngle = 0.0,
    this.endAngle = 2 * math.pi, // 2π radians (full circle)
  }) : assert(colors.length >= 2, 'At least 2 colors are required for a gradient');

  /// Creates the Flutter gradient object based on this configuration
  Gradient toGradient() {
    switch (type) {
      case GradientType.linear:
        return LinearGradient(
          colors: colors,
          stops: stops,
          begin: _getBeginAlignment(),
          end: _getEndAlignment(),
        );
      case GradientType.radial:
        return RadialGradient(
          colors: colors,
          stops: stops,
          center: center,
          radius: radius,
        );
      case GradientType.sweep:
        return SweepGradient(
          colors: colors,
          stops: stops,
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
        );
    }
  }

  // Helper method to get begin alignment based on direction
  Alignment _getBeginAlignment() {
    switch (direction) {
      case GradientDirection.leftToRight: return Alignment.centerLeft;
      case GradientDirection.rightToLeft: return Alignment.centerRight;
      case GradientDirection.topToBottom: return Alignment.topCenter;
      case GradientDirection.bottomToTop: return Alignment.bottomCenter;
      case GradientDirection.topLeftToBottomRight: return Alignment.topLeft;
      case GradientDirection.topRightToBottomLeft: return Alignment.topRight;
      case GradientDirection.bottomLeftToTopRight: return Alignment.bottomLeft;
      case GradientDirection.bottomRightToTopLeft: return Alignment.bottomRight;
    }
  }

  // Helper method to get end alignment based on direction
  Alignment _getEndAlignment() {
    switch (direction) {
      case GradientDirection.leftToRight: return Alignment.centerRight;
      case GradientDirection.rightToLeft: return Alignment.centerLeft;
      case GradientDirection.topToBottom: return Alignment.bottomCenter;
      case GradientDirection.bottomToTop: return Alignment.topCenter;
      case GradientDirection.topLeftToBottomRight: return Alignment.bottomRight;
      case GradientDirection.topRightToBottomLeft: return Alignment.bottomLeft;
      case GradientDirection.bottomLeftToTopRight: return Alignment.topRight;
      case GradientDirection.bottomRightToTopLeft: return Alignment.topLeft;
    }
  }
  
  /// Creates a new gradient with reversed colors
  GradientConfig reversed() {
    return GradientConfig(
      colors: colors.reversed.toList(),
      stops: stops?.reversed.toList(),
      type: type,
      direction: direction,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  
  /// Creates a new gradient with rotated direction (for linear gradients)
  GradientConfig rotated({int quarterTurns = 1}) {
    if (type != GradientType.linear) {
      return this;
    }
    
    final directions = [
      GradientDirection.leftToRight,
      GradientDirection.bottomToTop,
      GradientDirection.rightToLeft,
      GradientDirection.topToBottom,
    ];
    
    final diagonalDirections = [
      GradientDirection.topLeftToBottomRight,
      GradientDirection.bottomLeftToTopRight,
      GradientDirection.bottomRightToTopLeft,
      GradientDirection.topRightToBottomLeft,
    ];
    
    GradientDirection newDirection;
    
    if (directions.contains(direction)) {
      final currentIndex = directions.indexOf(direction);
      final newIndex = (currentIndex + quarterTurns) % 4;
      newDirection = directions[newIndex];
    } else {
      final currentIndex = diagonalDirections.indexOf(direction);
      final newIndex = (currentIndex + quarterTurns) % 4;
      newDirection = diagonalDirections[newIndex];
    }
    
    return GradientConfig(
      colors: colors,
      stops: stops,
      type: type,
      direction: newDirection,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  
  /// Creates a new gradient with a color tint applied
  GradientConfig tinted(Color tintColor, {double strength = 0.2}) {
    final newColors = colors.map((color) {
      return Color.lerp(color, tintColor, strength)!;
    }).toList();
    
    return GradientConfig(
      colors: newColors,
      stops: stops,
      type: type,
      direction: direction,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  
  /// Creates a new gradient with adjusted brightness
  GradientConfig withBrightness(double factor) {
    assert(factor >= 0, 'Brightness factor must be >= 0');
    
    final newColors = colors.map((color) {
      final hslColor = HSLColor.fromColor(color);
      return hslColor.withLightness((hslColor.lightness * factor).clamp(0.0, 1.0)).toColor();
    }).toList();
    
    return GradientConfig(
      colors: newColors,
      stops: stops,
      type: type,
      direction: direction,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  
  /// Creates a new gradient with adjusted saturation
  GradientConfig withSaturation(double factor) {
    assert(factor >= 0, 'Saturation factor must be >= 0');
    
    final newColors = colors.map((color) {
      final hslColor = HSLColor.fromColor(color);
      return hslColor.withSaturation((hslColor.saturation * factor).clamp(0.0, 1.0)).toColor();
    }).toList();
    
    return GradientConfig(
      colors: newColors,
      stops: stops,
      type: type,
      direction: direction,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  
  /// Factory constructor to create a gradient from a single color with varying opacity
  factory GradientConfig.fromColor({
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
  
  /// Factory constructor to create a monochromatic gradient from a single color
  factory GradientConfig.monochromatic({
    required Color color,
    int steps = 5,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
  }) {
    final List<Color> colors = [];
    final hslColor = HSLColor.fromColor(color);
    
    for (int i = 0; i < steps; i++) {
      final double lightness = 0.1 + (0.8 * i / (steps - 1));
      colors.add(hslColor.withLightness(lightness).toColor());
    }
    
    return GradientConfig(
      colors: colors,
      type: type,
      direction: direction,
    );
  }
  
  /// Factory constructor to create a gradient by mixing two colors
  factory GradientConfig.mix({
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
  
  /// Factory constructor to create a complementary gradient
  factory GradientConfig.complementary({
    required Color baseColor,
    int steps = 5,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
  }) {
    final HSLColor hslColor = HSLColor.fromColor(baseColor);
    final HSLColor complementary = hslColor.withHue((hslColor.hue + 180) % 360);
    
    return GradientConfig.mix(
      color1: baseColor,
      color2: complementary.toColor(),
      steps: steps,
      type: type,
      direction: direction,
    );
  }
  
  /// Factory constructor to create a triadic gradient
  factory GradientConfig.triadic({
    required Color baseColor,
    GradientType type = GradientType.linear,
    GradientDirection direction = GradientDirection.leftToRight,
  }) {
    final HSLColor hslColor = HSLColor.fromColor(baseColor);
    final HSLColor color2 = hslColor.withHue((hslColor.hue + 120) % 360);
    final HSLColor color3 = hslColor.withHue((hslColor.hue + 240) % 360);
    
    return GradientConfig(
      colors: [baseColor, color2.toColor(), color3.toColor()],
      type: type,
      direction: direction,
    );
  }
  
  /// Factory constructor to create a rainbow gradient
  factory GradientConfig.rainbow({
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
  
  /// Factory constructor to create a gradient with custom angle for linear gradients
  factory GradientConfig.angle({
    required List<Color> colors,
    List<double>? stops,
    required double angle, // in degrees
  }) {
    // Convert angle to radians and normalize
    final double radians = (angle % 360) * math.pi / 180;
    
    // Calculate alignment points based on angle
    final double dx = math.cos(radians);
    final double dy = math.sin(radians);
    
    // Choose the direction closest to the specified angle
    // This is a simple approximation since we can't use custom alignments directly
    GradientDirection direction;
    
    // Convert angle to 0-360 range
    final normalizedAngle = (angle % 360 + 360) % 360;
    
    if (normalizedAngle >= 337.5 || normalizedAngle < 22.5) {
      direction = GradientDirection.leftToRight;
    } else if (normalizedAngle >= 22.5 && normalizedAngle < 67.5) {
      direction = GradientDirection.topLeftToBottomRight;
    } else if (normalizedAngle >= 67.5 && normalizedAngle < 112.5) {
      direction = GradientDirection.topToBottom;
    } else if (normalizedAngle >= 112.5 && normalizedAngle < 157.5) {
      direction = GradientDirection.topRightToBottomLeft;
    } else if (normalizedAngle >= 157.5 && normalizedAngle < 202.5) {
      direction = GradientDirection.rightToLeft;
    } else if (normalizedAngle >= 202.5 && normalizedAngle < 247.5) {
      direction = GradientDirection.bottomRightToTopLeft;
    } else if (normalizedAngle >= 247.5 && normalizedAngle < 292.5) {
      direction = GradientDirection.bottomToTop;
    } else {
      direction = GradientDirection.bottomLeftToTopRight;
    }
    
    return GradientConfig(
      colors: colors,
      stops: stops,
      type: GradientType.linear,
      direction: direction,
    );
  }
  
  /// Factory constructor to create a gradient for shading (dark to light or light to dark)
  factory GradientConfig.shade({
    required Color color,
    bool darkToLight = true,
    GradientDirection direction = GradientDirection.topToBottom,
    double darkFactor = 0.2,
    double lightFactor = 0.2,
  }) {
    final HSLColor hslColor = HSLColor.fromColor(color);
    
    final darkerColor = hslColor.withLightness(
      (hslColor.lightness - darkFactor).clamp(0.0, 1.0)
    ).toColor();
    
    final lighterColor = hslColor.withLightness(
      (hslColor.lightness + lightFactor).clamp(0.0, 1.0)
    ).toColor();
    
    return GradientConfig(
      colors: darkToLight ? [darkerColor, color, lighterColor] : [lighterColor, color, darkerColor],
      type: GradientType.linear,
      direction: direction,
    );
  }
}