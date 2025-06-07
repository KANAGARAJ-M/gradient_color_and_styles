import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A card widget with a gradient background
class GradientCard extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The child widget
  final Widget? child;
  
  /// Border radius for the card
  final BorderRadius? borderRadius;
  
  /// Width of the card
  final double? width;
  
  /// Height of the card
  final double? height;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Elevation of the card
  final double elevation;
  
  /// Shadow color for the card
  final Color? shadowColor;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Callback when the card is long pressed
  final VoidCallback? onLongPress;
  
  /// Border for the card
  final Border? border;
  
  /// Whether to show a splash effect when tapped
  final bool splashEnabled;
  
  /// Color of the splash effect
  final Color? splashColor;
  
  /// Highlight color when pressed
  final Color? highlightColor;
  
  /// Alignment of the child within the card
  final Alignment alignment;
  
  /// Shape of the card (overrides borderRadius if provided)
  final ShapeBorder? shape;
  
  /// Whether the card should have a hover effect
  final bool enableHover;
  
  /// Scale factor when card is hovered or pressed
  final double hoverScale;
  
  /// Duration for animations
  final Duration animationDuration;
  
  /// Clip behavior for the card
  final Clip clipBehavior;
  
  /// Background color for the container (used with gradient)
  final Color? backgroundColor;
  
  /// Whether to use Material design ink effects
  final bool useMaterialInkEffects;
  
  /// Creates a new gradient card
  const GradientCard({
    super.key,
    required this.gradient,
    this.child,
    this.borderRadius,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.elevation = 4.0,
    this.shadowColor,
    this.onTap,
    this.onLongPress,
    this.border,
    this.splashEnabled = true,
    this.splashColor,
    this.highlightColor,
    this.alignment = Alignment.center,
    this.shape,
    this.enableHover = false,
    this.hoverScale = 1.03,
    this.animationDuration = const Duration(milliseconds: 200),
    this.clipBehavior = Clip.antiAlias,
    this.backgroundColor,
    this.useMaterialInkEffects = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the effective shape to use
    final effectiveShape = shape ?? RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
    
    // Create the gradient container
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: gradient.toGradient(),
        border: border,
        color: backgroundColor,
      ),
      child: child,
    );
    
    // Create the card with the container as its child
    Widget result = Card(
      elevation: elevation,
      shadowColor: shadowColor,
      margin: margin,
      shape: effectiveShape,
      clipBehavior: clipBehavior,
      child: cardContent,
    );
    
    // Add tap behavior if needed
    if (onTap != null || onLongPress != null) {
      if (useMaterialInkEffects) {
        // Use Material ink effects
        result = Card(
          elevation: elevation,
          shadowColor: shadowColor,
          margin: margin,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            splashColor: splashEnabled ? splashColor : Colors.transparent,
            highlightColor: splashEnabled ? highlightColor : Colors.transparent,
            child: cardContent,
          ),
        );
      } else {
        // Use simple GestureDetector without ink effects
        result = Card(
          elevation: elevation,
          shadowColor: shadowColor,
          margin: margin,
          shape: effectiveShape,
          clipBehavior: clipBehavior,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: cardContent,
          ),
        );
      }
    }
    
    // Add hover effect if enabled
    if (enableHover) {
      result = _addHoverEffect(result);
    }
    
    return result;
  }
  
  /// Adds a hover/press scale effect to the widget
  Widget _addHoverEffect(Widget child) {
    bool isHovered = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isHovered = true),
            onTapUp: (_) => setState(() => isHovered = false),
            onTapCancel: () => setState(() => isHovered = false),
            child: AnimatedScale(
              scale: isHovered ? hoverScale : 1.0,
              duration: animationDuration,
              child: child,
            ),
          ),
        );
      },
    );
  }
  
  /// Creates an elevated card with rounded corners
  factory GradientCard.elevated({
    required GradientConfig gradient,
    required Widget child,
    double elevation = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return GradientCard(
      gradient: gradient,
      child: child,
      elevation: elevation,
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      onTap: onTap,
      splashEnabled: onTap != null,
    );
  }
  
  /// Creates a card with a header and content section
  factory GradientCard.withHeader({
    required GradientConfig headerGradient,
    required GradientConfig bodyGradient,
    required Widget headerContent,
    required Widget bodyContent,
    double headerHeight = 80.0,
    EdgeInsetsGeometry headerPadding = const EdgeInsets.all(16.0),
    EdgeInsetsGeometry bodyPadding = const EdgeInsets.all(16.0),
    BorderRadius? borderRadius,
    double elevation = 4.0,
    VoidCallback? onTap,
  }) {
    return GradientCard(
      gradient: bodyGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      elevation: elevation,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: headerHeight,
            padding: headerPadding,
            decoration: BoxDecoration(
              gradient: headerGradient.toGradient(),
              borderRadius: BorderRadius.only(
                topLeft: (borderRadius ?? BorderRadius.circular(12)).topLeft,
                topRight: (borderRadius ?? BorderRadius.circular(12)).topRight,
              ),
            ),
            child: headerContent,
          ),
          Padding(
            padding: bodyPadding,
            child: bodyContent,
          ),
        ],
      ),
    );
  }
  
  /// Creates a circular card with a gradient background
  factory GradientCard.circular({
    required GradientConfig gradient,
    required Widget child,
    double size = 100.0,
    double elevation = 4.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    VoidCallback? onTap,
  }) {
    return GradientCard(
      gradient: gradient,
      elevation: elevation,
      padding: padding,
      width: size,
      height: size,
      onTap: onTap,
      shape: const CircleBorder(),
      child: child,
    );
  }
}