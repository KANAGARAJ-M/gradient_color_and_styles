import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A toggle switch with gradient when active
class GradientToggle extends StatelessWidget {
  /// The gradient configuration to use when active
  final GradientConfig activeGradient;
  
  /// Whether the toggle is active
  final bool value;
  
  /// Callback when the value changes
  final ValueChanged<bool> onChanged;
  
  /// Width of the toggle
  final double width;
  
  /// Height of the toggle
  final double height;
  
  /// Inactive color of the toggle
  final Color inactiveColor;
  
  /// Creates a new gradient toggle
  const GradientToggle({
    super.key,
    required this.activeGradient,
    required this.value,
    required this.onChanged,
    this.width = 50.0,
    this.height = 30.0,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: value ? activeGradient.toGradient() : null,
          color: value ? null : inactiveColor,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? width - height + 2 : 2,
              top: 2,
              bottom: 2,
              child: Container(
                width: height - 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}