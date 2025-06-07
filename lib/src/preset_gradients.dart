import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A collection of preset gradient configurations
class PresetGradients {
  /// A vibrant sunset gradient (orange to pink)
  static GradientConfig sunset =  GradientConfig(
    colors: [Color(0xFFFE6B8B), Color(0xFFFF8E53)],
    type: GradientType.linear,
    direction: GradientDirection.topToBottom,
  );

  /// A blue-purple ocean gradient
  static GradientConfig ocean =  GradientConfig(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    type: GradientType.linear,
    direction: GradientDirection.leftToRight,
  );

  /// A green nature gradient
  static GradientConfig nature = GradientConfig(
    colors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
    type: GradientType.linear,
    direction: GradientDirection.bottomToTop,
  );

  /// A deep space gradient
  static GradientConfig space = GradientConfig(
    colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    type: GradientType.linear,
    direction: GradientDirection.topLeftToBottomRight,
  );

  /// A sunrise gradient (3 colors)
  static GradientConfig sunrise = GradientConfig(
    colors: [Color(0xFFff512f), Color(0xFFf09819), Color(0xFFff512f)],
    type: GradientType.linear,
    direction: GradientDirection.leftToRight,
  );

  /// A rainbow gradient (6 colors)
  static GradientConfig rainbow = GradientConfig(
    colors: [
      Color(0xFFff0000), // Red
      Color(0xFFff9900), // Orange
      Color(0xFFffff00), // Yellow
      Color(0xFF00ff00), // Green
      Color(0xFF0000ff), // Blue
      Color(0xFF9900ff), // Purple
    ],
    type: GradientType.linear,
    direction: GradientDirection.leftToRight,
  );
  
  /// A dark to light gradient in circular form
  static GradientConfig darkRadial = GradientConfig(
    colors: [Colors.black, Colors.transparent],
    type: GradientType.radial,
    radius: 0.8,
  );
  
  /// A colorful sweep gradient
  static GradientConfig colorWheel = GradientConfig(
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.red,
    ],
    type: GradientType.sweep,
  );
}