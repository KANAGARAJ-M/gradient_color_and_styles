import 'package:flutter/material.dart';
import 'gradient_config.dart';
import 'preset_gradients.dart';

/// A container widget with a customizable gradient background
class GradientContainer extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The child widget
  final Widget? child;
  
  /// Border radius for the container
  final BorderRadius? borderRadius;
  
  /// Width of the container
  final double? width;
  
  /// Height of the container
  final double? height;
  
  /// Margin around the container
  final EdgeInsetsGeometry? margin;
  
  /// Padding inside the container
  final EdgeInsetsGeometry? padding;
  
  /// Alignment of the child within the container
  final Alignment? alignment;
  
  /// Border for the container
  final BoxBorder? border;
  
  /// Elevation of the container (adds shadow)
  final double elevation;
  
  /// Shadow color for the container
  final Color shadowColor;
  
  /// Callback when the container is tapped
  final VoidCallback? onTap;
  
  /// Callback when the container is long pressed
  final VoidCallback? onLongPress;
  
  /// Whether to animate scale on tap/hover
  final bool enableInteractiveEffects;
  
  /// Scale factor when container is hovered or pressed
  final double hoverScale;
  
  /// Duration for animations
  final Duration animationDuration;
  
  /// Clip behavior for the container
  final Clip clipBehavior;
  
  /// Shape of the container (overrides borderRadius if provided)
  final BoxShape shape;
  
  /// Background color (used with gradient)
  final Color? backgroundColor;
  
  /// Creates a new gradient container
  const GradientContainer({
    super.key,
    required this.gradient,
    this.child,
    this.borderRadius,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.alignment,
    this.border,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
    this.onTap,
    this.onLongPress,
    this.enableInteractiveEffects = false,
    this.hoverScale = 1.03,
    this.animationDuration = const Duration(milliseconds: 200),
    this.clipBehavior = Clip.none,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        gradient: gradient.toGradient(),
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        shape: shape,
        border: border,
        color: backgroundColor,
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 2,
            offset: Offset(0, elevation / 2),
          ),
        ] : null,
      ),
      child: child,
    );
    
    // Add margin if specified
    if (margin != null) {
      container = Padding(
        padding: margin!,
        child: container,
      );
    }
    
    // Add tap behavior if specified
    if (onTap != null || onLongPress != null) {
      container = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: container,
      );
      
      // Add interactive effects if enabled
      if (enableInteractiveEffects) {
        container = _addInteractiveEffects(container);
      }
    }
    
    return container;
  }
  
  /// Adds hover/press effects to the widget
  Widget _addInteractiveEffects(Widget child) {
    bool isActive = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isActive = true),
          onExit: (_) => setState(() => isActive = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isActive = true),
            onTapUp: (_) => setState(() => isActive = false),
            onTapCancel: () => setState(() => isActive = false),
            child: AnimatedScale(
              scale: isActive ? hoverScale : 1.0,
              duration: animationDuration,
              child: child,
            ),
          ),
        );
      },
    );
  }
  
  /// Creates a card-like container with elevation
  factory GradientContainer.card({
    required GradientConfig gradient,
    required Widget child,
    double elevation = 4.0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    VoidCallback? onTap,
  }) {
    return GradientContainer(
      gradient: gradient,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      padding: padding,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: onTap != null,
    );
  }
  
  /// Creates a circular container
  factory GradientContainer.circular({
    required GradientConfig gradient,
    required Widget child,
    double size = 100.0,
    EdgeInsetsGeometry? padding,
    double elevation = 0.0,
  }) {
    return GradientContainer(
      gradient: gradient,
      child: child,
      width: size,
      height: size,
      padding: padding,
      elevation: elevation,
      shape: BoxShape.circle,
    );
  }
  
  /// Creates a banner-style container
  factory GradientContainer.banner({
    required GradientConfig gradient,
    required Widget child,
    double height = 120.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return GradientContainer(
      gradient: gradient,
      child: child,
      height: height,
      padding: padding,
      width: double.infinity,
    );
  }
  
  /// Creates a container with fire-themed gradient
  factory GradientContainer.fire({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: GradientConfig(
        colors: [Colors.red, Colors.orange, Colors.amber],
        direction: GradientDirection.topLeftToBottomRight,
      ),
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with ocean/water-themed gradient
  factory GradientContainer.water({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.ocean,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with sky-themed gradient
  factory GradientContainer.sky({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: GradientConfig(
        colors: [Colors.lightBlue.shade300, Colors.lightBlue.shade100, Colors.white],
        direction: GradientDirection.topToBottom,
      ),
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with nature/forest-themed gradient
  factory GradientContainer.nature({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.nature,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with sunset-themed gradient
  factory GradientContainer.sunset({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.sunset,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with rainbow gradient
  factory GradientContainer.rainbow({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.rainbow,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with space/galaxy-themed gradient
  factory GradientContainer.space({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.space,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with dark radial gradient (spotlight effect)
  factory GradientContainer.darkRadial({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    Alignment center = Alignment.center,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.darkRadial,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: center,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
  
  /// Creates a container with sunrise-themed gradient
  factory GradientContainer.sunrise({
    required Widget child,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 0.0,
    VoidCallback? onTap,
    bool enableInteractiveEffects = false,
  }) {
    return GradientContainer(
      gradient: PresetGradients.sunrise,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      elevation: elevation,
      onTap: onTap,
      enableInteractiveEffects: enableInteractiveEffects,
    );
  }
}