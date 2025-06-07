import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'gradient_config.dart';

/// A Floating Action Button with gradient background
class GradientFAB extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// Icon for the FAB
  final IconData icon;
  
  /// Size of the icon
  final double iconSize;
  
  /// Color of the icon
  final Color iconColor;
  
  /// Callback when the button is pressed
  final VoidCallback onPressed;
  
  /// Extended label text (optional)
  final String? label;
  
  /// Text style for extended label
  final TextStyle? labelStyle;
  
  /// Whether the FAB is mini sized
  final bool mini;
  
  /// Elevation of the button when not pressed
  final double elevation;
  
  /// Elevation when the button is pressed
  final double highlightElevation;
  
  /// Shadow color of the button
  final Color? shadowColor;
  
  /// Shape of the button
  final ShapeBorder? shape;
  
  /// Tooltip text for the button
  final String? tooltip;
  
  /// Hero tag for hero animations
  final Object? heroTag;
  
  /// Whether to show a splash effect when pressed
  final bool enableFeedback;
  
  /// Focus node for keyboard focus
  final FocusNode? focusNode;
  
  /// Whether to focus this widget automatically
  final bool autofocus;
  
  /// Padding for extended FAB
  final EdgeInsetsGeometry? extendedPadding;
  
  /// Background color (used as base with gradient)
  final Color backgroundColor;
  
  /// Foreground color (for material states)
  final Color? foregroundColor;
  
  /// Whether to animate the gradient when pressed
  final bool animateGradient;
  
  /// Duration for the gradient animation
  final Duration animationDuration;
  
  /// Specific FloatingActionButtonLocation
  final FloatingActionButtonLocation? location;
  
  /// Whether the gradient extends to the edges of the button
  final bool extendGradientToEdges;
  
  /// Creates a new gradient floating action button
  const GradientFAB({
    super.key,
    required this.gradient,
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    this.iconColor = Colors.white,
    this.label,
    this.labelStyle,
    this.mini = false,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.shadowColor,
    this.shape,
    this.tooltip,
    this.heroTag,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.extendedPadding,
    this.backgroundColor = Colors.white,
    this.foregroundColor,
    this.animateGradient = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.location,
    this.extendGradientToEdges = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget buttonChild = label != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: iconSize),
              const SizedBox(width: 8),
              Text(label!, style: labelStyle ?? TextStyle(color: iconColor)),
            ],
          )
        : Icon(icon, color: iconColor, size: iconSize);

    final effectiveShape = shape ?? const CircleBorder();

    return AnimatedBuilder(
      animation: animateGradient 
          ? AnimationController(vsync: _DummyTickerProvider(), duration: animationDuration)
          : const AlwaysStoppedAnimation(0),
      builder: (context, _) {
        return FloatingActionButton(
          onPressed: onPressed,
          mini: mini,
          elevation: elevation,
          highlightElevation: highlightElevation,
          tooltip: tooltip,
          heroTag: heroTag,
          enableFeedback: enableFeedback,
          shape: effectiveShape,
          focusNode: focusNode,
          autofocus: autofocus,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: ShaderMask(
            shaderCallback: (bounds) => gradient.toGradient().createShader(
              extendGradientToEdges 
                  ? bounds 
                  : Rect.fromCenter(
                      center: bounds.center, 
                      width: bounds.width * 0.8, 
                      height: bounds.height * 0.8,
                    ),
            ),
            child: buttonChild,
          ),
        );
      },
    );
  }
  
  /// Creates an extended FAB with a gradient
  factory GradientFAB.extended({
    required GradientConfig gradient,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    TextStyle? labelStyle,
    double iconSize = 24.0,
    Color iconColor = Colors.white,
    double elevation = 6.0,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
  }) {
    return GradientFAB(
      gradient: gradient,
      icon: icon,
      iconSize: iconSize,
      iconColor: iconColor,
      onPressed: onPressed,
      label: label,
      labelStyle: labelStyle,
      elevation: elevation,
      shadowColor: shadowColor,
      extendedPadding: padding,
    );
  }
  
  /// Creates a large FAB with a gradient
  factory GradientFAB.large({
    required GradientConfig gradient,
    required IconData icon,
    required VoidCallback onPressed,
    double iconSize = 36.0,
    Color iconColor = Colors.white,
    double elevation = 6.0,
  }) {
    return GradientFAB(
      gradient: gradient,
      icon: icon,
      iconSize: iconSize,
      iconColor: iconColor,
      onPressed: onPressed,
      elevation: elevation,
    );
  }
  
  /// Creates a circular FAB with a gradient
  factory GradientFAB.circular({
    required GradientConfig gradient,
    required IconData icon,
    required VoidCallback onPressed,
    double size = 56.0,
    double iconSize = 24.0,
    Color iconColor = Colors.white,
    double elevation = 6.0,
  }) {
    return GradientFAB(
      gradient: gradient,
      icon: icon,
      iconSize: iconSize,
      iconColor: iconColor,
      onPressed: onPressed,
      elevation: elevation,
      shape: CircleBorder(),
    );
  }
}

/// Dummy TickerProvider for animations
class _DummyTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick, debugLabel: 'GradientFAB');
}