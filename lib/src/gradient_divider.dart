import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A divider with gradient color
class GradientDivider extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The height of the divider
  final double height;
  
  /// The thickness of the divider
  final double thickness;
  
  /// The indent on the left side
  final double indent;
  
  /// The indent on the right side
  final double endIndent;
  
  /// Whether this is a vertical divider
  final bool vertical;
  
  /// Border radius for rounded divider ends
  final BorderRadius? borderRadius;
  
  /// Shadow elevation for the divider
  final double elevation;
  
  /// Shadow color for the divider
  final Color shadowColor;
  
  /// Dash pattern (null for solid line)
  final List<double>? dashPattern;
  
  /// Whether to animate the divider when it appears
  final bool animate;
  
  /// Animation duration
  final Duration animationDuration;
  
  /// Animation curve
  final Curve animationCurve;
  
  /// Width of the divider (used for vertical dividers)
  final double width;
  
  /// Creates a new gradient divider
  const GradientDivider({
    super.key,
    required this.gradient,
    this.height = 16.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.vertical = false,
    this.borderRadius,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
    this.dashPattern,
    this.animate = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
    this.width = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final divider = _buildDivider();
    
    // Add animation if needed
    if (animate) {
      return AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        child: divider,
      );
    }
    
    return divider;
  }
  
  Widget _buildDivider() {
    if (dashPattern != null) {
      return _buildDashedDivider();
    }
    
    if (vertical) {
      return Container(
        width: width,
        padding: EdgeInsets.only(left: (width - thickness) / 2),
        child: Container(
          width: thickness,
          margin: EdgeInsetsDirectional.only(
            top: indent,
            bottom: endIndent,
          ),
          decoration: BoxDecoration(
            gradient: gradient.toGradient(),
            borderRadius: borderRadius,
            boxShadow: elevation > 0 ? [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: elevation,
                spreadRadius: elevation / 2,
                offset: Offset(0, elevation / 2),
              ),
            ] : null,
          ),
        ),
      );
    } else {
      return Container(
        height: height,
        padding: EdgeInsets.only(top: (height - thickness) / 2),
        child: Container(
          height: thickness,
          margin: EdgeInsetsDirectional.only(
            start: indent,
            end: endIndent,
          ),
          decoration: BoxDecoration(
            gradient: gradient.toGradient(),
            borderRadius: borderRadius,
            boxShadow: elevation > 0 ? [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: elevation,
                spreadRadius: elevation / 2,
                offset: Offset(0, elevation / 2),
              ),
            ] : null,
          ),
        ),
      );
    }
  }
  
  Widget _buildDashedDivider() {
    if (vertical) {
      return Container(
        width: width,
        child: CustomPaint(
          painter: _DashedLinePainter(
            gradient: gradient.toGradient(),
            vertical: true,
            thickness: thickness,
            dashPattern: dashPattern!,
            indent: indent,
            endIndent: endIndent,
            borderRadius: borderRadius,
          ),
          child: const SizedBox.expand(),
        ),
      );
    } else {
      return Container(
        height: height,
        child: CustomPaint(
          painter: _DashedLinePainter(
            gradient: gradient.toGradient(),
            vertical: false,
            thickness: thickness,
            dashPattern: dashPattern!,
            indent: indent,
            endIndent: endIndent,
            borderRadius: borderRadius,
          ),
          child: const SizedBox.expand(),
        ),
      );
    }
  }
  
  /// Creates a horizontal divider
  factory GradientDivider.horizontal({
    required GradientConfig gradient,
    double thickness = 1.0,
    double indent = 16.0,
    double endIndent = 16.0,
    bool rounded = true,
    double elevation = 0.0,
  }) {
    return GradientDivider(
      gradient: gradient,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      borderRadius: rounded ? BorderRadius.circular(thickness / 2) : null,
      elevation: elevation,
    );
  }
  
  /// Creates a vertical divider
  factory GradientDivider.vertical({
    required GradientConfig gradient,
    double thickness = 1.0,
    double indent = 16.0,
    double endIndent = 16.0,
    bool rounded = true,
    double elevation = 0.0,
  }) {
    return GradientDivider(
      gradient: gradient,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      vertical: true,
      borderRadius: rounded ? BorderRadius.circular(thickness / 2) : null,
      elevation: elevation,
    );
  }
  
  /// Creates a dashed horizontal divider
  factory GradientDivider.dashed({
    required GradientConfig gradient,
    double thickness = 1.0,
    double indent = 16.0,
    double endIndent = 16.0,
    List<double> dashPattern = const [4.0, 2.0],
    bool rounded = true,
  }) {
    return GradientDivider(
      gradient: gradient,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      dashPattern: dashPattern,
      borderRadius: rounded ? BorderRadius.circular(thickness / 2) : null,
    );
  }
}

/// Custom painter for drawing dashed lines with gradient
class _DashedLinePainter extends CustomPainter {
  final Gradient gradient;
  final bool vertical;
  final double thickness;
  final List<double> dashPattern;
  final double indent;
  final double endIndent;
  final BorderRadius? borderRadius;
  
  _DashedLinePainter({
    required this.gradient,
    required this.vertical,
    required this.thickness,
    required this.dashPattern,
    required this.indent,
    required this.endIndent,
    this.borderRadius,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;
    
    if (vertical) {
      final Rect shaderRect = Rect.fromLTWH(0, 0, thickness, size.height - indent - endIndent);
      paint.shader = gradient.createShader(shaderRect);
      
      final double x = size.width / 2;
      double startY = indent;
      
      bool isDash = true;
      int patternIndex = 0;
      
      while (startY < size.height - endIndent) {
        final double dashLength = dashPattern[patternIndex % dashPattern.length];
        
        if (isDash) {
          final double endY = (startY + dashLength).clamp(0.0, size.height - endIndent);
          
          if (borderRadius != null) {
            final path = Path()
              ..moveTo(x, startY)
              ..lineTo(x, endY);
            canvas.drawPath(path, paint);
          } else {
            canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
          }
        }
        
        startY += dashLength;
        isDash = !isDash;
        patternIndex++;
      }
    } else {
      final Rect shaderRect = Rect.fromLTWH(indent, 0, size.width - indent - endIndent, thickness);
      paint.shader = gradient.createShader(shaderRect);
      
      final double y = size.height / 2;
      double startX = indent;
      
      bool isDash = true;
      int patternIndex = 0;
      
      while (startX < size.width - endIndent) {
        final double dashLength = dashPattern[patternIndex % dashPattern.length];
        
        if (isDash) {
          final double endX = (startX + dashLength).clamp(0.0, size.width - endIndent);
          
          if (borderRadius != null) {
            final path = Path()
              ..moveTo(startX, y)
              ..lineTo(endX, y);
            canvas.drawPath(path, paint);
          } else {
            canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
          }
        }
        
        startX += dashLength;
        isDash = !isDash;
        patternIndex++;
      }
    }
  }
  
  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
           oldDelegate.vertical != vertical ||
           oldDelegate.thickness != thickness ||
           oldDelegate.dashPattern != dashPattern ||
           oldDelegate.indent != indent ||
           oldDelegate.endIndent != endIndent ||
           oldDelegate.borderRadius != borderRadius;
  }
}