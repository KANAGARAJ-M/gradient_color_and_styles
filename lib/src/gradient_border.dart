import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A container with gradient border
class GradientBorder extends StatelessWidget {
  /// The gradient configuration to use for the border
  final GradientConfig gradient;
  
  /// The child widget
  final Widget child;
  
  /// Width of the border
  final double borderWidth;
  
  /// Border radius
  final BorderRadius borderRadius;
  
  /// Padding inside the border
  final EdgeInsetsGeometry padding;
  
  /// Margins around the border
  final EdgeInsetsGeometry? margin;
  
  /// Background color for the content
  final Color? backgroundColor;
  
  /// Shadow elevation for the container
  final double elevation;
  
  /// Shadow color for the container
  final Color shadowColor;
  
  /// Border dash pattern (if null, solid border is used)
  final List<double>? dashPattern;
  
  /// Callback when the container is tapped
  final VoidCallback? onTap;
  
  /// Whether to use a circular shape instead of rounded rectangle
  final bool isCircular;
  
  /// Border alignment (0.0 = inner, 0.5 = center, 1.0 = outer)
  final double borderAlignment;
  
  /// Clip behavior for the container
  final Clip clipBehavior;
  
  /// Animation duration for state changes
  final Duration animationDuration;
  
  /// Scale factor when pressed (if onTap is provided)
  final double pressedScale;
  
  /// Creates a new gradient border
  const GradientBorder({
    super.key,
    required this.gradient,
    required this.child,
    this.borderWidth = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.backgroundColor,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
    this.dashPattern,
    this.onTap,
    this.isCircular = false,
    this.borderAlignment = 0.5,
    this.clipBehavior = Clip.antiAlias,
    this.animationDuration = const Duration(milliseconds: 200),
    this.pressedScale = 0.98,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    
    Widget result = _buildBorderedContainer(context, effectiveBackgroundColor);
    
    // Apply margin if specified
    if (margin != null) {
      result = Padding(
        padding: margin!,
        child: result,
      );
    }
    
    // Apply tap behavior if specified
    if (onTap != null) {
      result = _addTapBehavior(result);
    }
    
    // Apply elevation if specified
    if (elevation > 0) {
      result = _addElevation(result);
    }
    
    return result;
  }
  
  /// Builds the main bordered container
  Widget _buildBorderedContainer(BuildContext context, Color effectiveBackgroundColor) {
    final shape = isCircular ? BoxShape.circle : BoxShape.rectangle;
    
    if (dashPattern != null) {
      // For dashed border, we need a custom approach
      return _buildDashedBorder(context, effectiveBackgroundColor, shape);
    }
    
    // Regular gradient border using nested containers
    return Container(
      decoration: BoxDecoration(
        gradient: gradient.toGradient(),
        borderRadius: isCircular ? null : borderRadius,
        shape: shape,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: isCircular 
              ? null 
              : BorderRadius.all(
                  Radius.circular(borderRadius.topLeft.x - borderWidth * borderAlignment),
                ),
          shape: shape,
        ),
        margin: EdgeInsets.all(borderWidth),
        padding: padding,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
  
  /// Builds a container with dashed border
  Widget _buildDashedBorder(BuildContext context, Color effectiveBackgroundColor, BoxShape shape) {
    return CustomPaint(
      painter: _GradientDashedBorderPainter(
        gradient: gradient.toGradient(),
        strokeWidth: borderWidth,
        dashPattern: dashPattern!,
        radius: borderRadius.topLeft.x,
        shape: shape,
      ),
      child: Container(
        padding: EdgeInsets.all(borderWidth).add(padding),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: isCircular ? null : borderRadius,
          shape: shape,
        ),
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
  
  /// Adds tap behavior to the widget
  Widget _addTapBehavior(Widget child) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: animationDuration,
        child: child,
      ),
    );
  }
  
  /// Adds elevation/shadow to the widget
  Widget _addElevation(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: isCircular ? null : borderRadius,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 3,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: child,
    );
  }
  
  /// Creates a gradient border with equal insets on all sides
  factory GradientBorder.all({
    required GradientConfig gradient,
    required Widget child,
    double width = 2.0,
    double radius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    Color? backgroundColor,
  }) {
    return GradientBorder(
      gradient: gradient,
      child: child,
      borderWidth: width,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      padding: padding,
      backgroundColor: backgroundColor,
    );
  }
  
  /// Creates a circular gradient border
  factory GradientBorder.circular({
    required GradientConfig gradient,
    required Widget child,
    double width = 2.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    Color? backgroundColor,
  }) {
    return GradientBorder(
      gradient: gradient,
      child: child,
      borderWidth: width,
      padding: padding,
      backgroundColor: backgroundColor,
      isCircular: true,
    );
  }
}

/// Custom painter for drawing dashed gradient borders
class _GradientDashedBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final List<double> dashPattern;
  final double radius;
  final BoxShape shape;
  
  _GradientDashedBorderPainter({
    required this.gradient,
    required this.strokeWidth,
    required this.dashPattern,
    required this.radius,
    required this.shape,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2, 
      strokeWidth / 2, 
      size.width - strokeWidth, 
      size.height - strokeWidth
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    if (shape == BoxShape.circle) {
      path.addOval(rect);
    } else {
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    }
    
    // Create a dash path
    final dashPath = Path();
    
    final dashArray = CircularIntervalList<double>(dashPattern);
    var start = 0.0;
    
    // Calculate the total length of the path
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;
    
    while (start < totalLength) {
      final dash = dashArray.next;
      final gap = dashArray.next;
      
      // Add dash segment
      dashPath.addPath(
        pathMetrics.extractPath(start, start + dash),
        Offset.zero,
      );
      
      start += dash + gap;
    }
    
    canvas.drawPath(dashPath, paint);
  }
  
  @override
  bool shouldRepaint(_GradientDashedBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.dashPattern != dashPattern ||
           oldDelegate.radius != radius ||
           oldDelegate.shape != shape;
  }
}

/// Helper class for cycling through a list of values
class CircularIntervalList<T> {
  final List<T> _values;
  int _index = 0;
  
  CircularIntervalList(this._values);
  
  T get next {
    if (_values.isEmpty) {
      throw Exception('CircularIntervalList cannot be empty');
    }
    
    final value = _values[_index];
    _index = (_index + 1) % _values.length;
    return value;
  }
}