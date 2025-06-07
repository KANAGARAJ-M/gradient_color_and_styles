import 'package:flutter/material.dart';
import 'gradient_config.dart';
import 'dart:math' as math;

/// A progress indicator with gradient fill
class GradientProgressIndicator extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The value of the progress (0.0 to 1.0)
  final double? value;
  
  /// The height of the progress indicator (for linear type)
  final double height;
  
  /// The border radius of the progress indicator (for linear type)
  final BorderRadius borderRadius;
  
  /// The background color
  final Color backgroundColor;
  
  /// Type of progress indicator (linear or circular)
  final ProgressType type;
  
  /// Size of the circular progress indicator (ignored for linear type)
  final double size;
  
  /// Stroke width for circular progress indicator (ignored for linear type)
  final double strokeWidth;
  
  /// Whether to show a buffer indicator
  final bool showBuffer;
  
  /// Buffer value (0.0 to 1.0, only used when showBuffer is true)
  final double bufferValue;
  
  /// Color of the buffer indicator
  final Color bufferColor;
  
  /// Whether to animate the progress
  final bool animate;
  
  /// Duration of the animation
  final Duration animationDuration;
  
  /// Curve of the animation
  final Curve animationCurve;
  
  /// Whether to show a label with the percentage
  final bool showPercentageLabel;
  
  /// Style for the percentage label
  final TextStyle? percentageLabelStyle;
  
  /// Format for the percentage label (e.g., '50%', '0.5')
  final String Function(double)? percentageLabelFormat;
  
  /// Stroke cap for the progress indicator
  final StrokeCap strokeCap;
  
  /// Elevation (shadow) for the progress indicator
  final double elevation;
  
  /// Shadow color for the progress indicator
  final Color shadowColor;
  
  /// Creates a new gradient progress indicator
  const GradientProgressIndicator({
    super.key,
    required this.gradient,
    this.value,
    this.height = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(2.0)),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.type = ProgressType.linear,
    this.size = 48.0,
    this.strokeWidth = 4.0,
    this.showBuffer = false,
    this.bufferValue = 0.0,
    this.bufferColor = const Color(0xFFB3E5FC),
    this.animate = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.showPercentageLabel = false,
    this.percentageLabelStyle,
    this.percentageLabelFormat,
    this.strokeCap = StrokeCap.round,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
  }) : assert(
         value == null || (value >= 0.0 && value <= 1.0), 
         'Value must be null or between 0.0 and 1.0'
       ),
       assert(
         bufferValue >= 0.0 && bufferValue <= 1.0,
         'Buffer value must be between 0.0 and 1.0'
       );

  @override
  Widget build(BuildContext context) {
    // Handle animation if enabled
    if (animate && value != null) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: value!),
        duration: animationDuration,
        curve: animationCurve,
        builder: (context, animatedValue, _) {
          return _buildProgressIndicator(context, animatedValue);
        },
      );
    }
    
    return _buildProgressIndicator(context, value);
  }
  
  /// Builds the appropriate progress indicator based on type
  Widget _buildProgressIndicator(BuildContext context, double? currentValue) {
    switch (type) {
      case ProgressType.linear:
        return _buildLinearProgressIndicator(context, currentValue);
      case ProgressType.circular:
        return _buildCircularProgressIndicator(context, currentValue);
    }
  }
  
  /// Builds a linear progress indicator
  Widget _buildLinearProgressIndicator(BuildContext context, double? currentValue) {
    Widget progressIndicator = Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 3,
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            // Buffer layer
            if (showBuffer && currentValue != null)
              Container(
                width: MediaQuery.of(context).size.width * bufferValue,
                decoration: BoxDecoration(
                  color: bufferColor,
                ),
              ),
            
            // Progress layer
            if (currentValue != null)
              Container(
                decoration: BoxDecoration(
                  gradient: gradient.toGradient(),
                ),
                width: MediaQuery.of(context).size.width * currentValue,
              )
            else
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
              ),
          ],
        ),
      ),
    );
    
    // Add percentage label if requested
    if (showPercentageLabel && currentValue != null) {
      progressIndicator = Stack(
        alignment: Alignment.center,
        children: [
          progressIndicator,
          Text(
            _formatPercentage(currentValue),
            style: percentageLabelStyle ?? 
                TextStyle(
                  color: _calculateLabelColor(currentValue),
                  fontSize: height * 0.7,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    }
    
    return progressIndicator;
  }
  
  /// Builds a circular progress indicator
  Widget _buildCircularProgressIndicator(BuildContext context, double? currentValue) {
    final Widget circularIndicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 3,
          ),
        ] : null,
      ),
      child: CustomPaint(
        painter: _GradientCircularProgressPainter(
          gradient: gradient.toGradient(),
          value: currentValue,
          backgroundColor: backgroundColor,
          bufferValue: showBuffer ? bufferValue : null,
          bufferColor: bufferColor,
          strokeWidth: strokeWidth,
          strokeCap: strokeCap,
        ),
        child: showPercentageLabel && currentValue != null
            ? Center(
                child: Text(
                  _formatPercentage(currentValue),
                  style: percentageLabelStyle ?? 
                      TextStyle(
                        color: _calculateLabelColor(currentValue),
                        fontSize: size * 0.2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            : null,
      ),
    );
    
    return circularIndicator;
  }
  
  /// Formats the percentage value for display
  String _formatPercentage(double value) {
    if (percentageLabelFormat != null) {
      return percentageLabelFormat!(value);
    }
    return '${(value * 100).toInt()}%';
  }
  
  /// Calculates the appropriate label color based on progress
  Color _calculateLabelColor(double value) {
    return value > 0.5 ? Colors.white : Colors.black87;
  }
  
  /// Creates a linear determinate progress indicator
  factory GradientProgressIndicator.linear({
    required GradientConfig gradient,
    required double value,
    double height = 8.0,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    bool animate = true,
  }) {
    return GradientProgressIndicator(
      gradient: gradient,
      value: value,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      backgroundColor: backgroundColor ?? const Color(0xFFE0E0E0),
      animate: animate,
      type: ProgressType.linear,
    );
  }
  
  /// Creates a linear indeterminate progress indicator
  factory GradientProgressIndicator.linearIndeterminate({
    required GradientConfig gradient,
    double height = 4.0,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return GradientProgressIndicator(
      gradient: gradient,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      backgroundColor: backgroundColor ?? const Color(0xFFE0E0E0),
      type: ProgressType.linear,
    );
  }
  
  /// Creates a circular determinate progress indicator
  factory GradientProgressIndicator.circular({
    required GradientConfig gradient,
    required double value,
    double size = 48.0,
    double strokeWidth = 4.0,
    Color? backgroundColor,
    bool showPercentageLabel = true,
    bool animate = true,
  }) {
    return GradientProgressIndicator(
      gradient: gradient,
      value: value,
      size: size,
      strokeWidth: strokeWidth,
      backgroundColor: backgroundColor ?? const Color(0xFFE0E0E0),
      showPercentageLabel: showPercentageLabel,
      animate: animate,
      type: ProgressType.circular,
    );
  }
  
  /// Creates a circular indeterminate progress indicator
  factory GradientProgressIndicator.circularIndeterminate({
    required GradientConfig gradient,
    double size = 48.0,
    double strokeWidth = 4.0,
    Color? backgroundColor,
  }) {
    return GradientProgressIndicator(
      gradient: gradient,
      size: size,
      strokeWidth: strokeWidth,
      backgroundColor: backgroundColor ?? const Color(0xFFE0E0E0),
      type: ProgressType.circular,
    );
  }
  
  /// Creates a buffer progress indicator
  factory GradientProgressIndicator.buffer({
    required GradientConfig gradient,
    required double value,
    required double bufferValue,
    double height = 4.0,
    Color? backgroundColor,
    Color? bufferColor,
  }) {
    return GradientProgressIndicator(
      gradient: gradient,
      value: value,
      height: height,
      backgroundColor: backgroundColor ?? const Color(0xFFE0E0E0),
      showBuffer: true,
      bufferValue: bufferValue,
      bufferColor: bufferColor ?? const Color(0xFFB3E5FC),
      type: ProgressType.linear,
    );
  }
}

/// Type of progress indicator
enum ProgressType {
  /// Linear progress indicator
  linear,
  
  /// Circular progress indicator
  circular,
}

/// Custom painter for circular gradient progress indicator
class _GradientCircularProgressPainter extends CustomPainter {
  final Gradient gradient;
  final double? value;
  final Color backgroundColor;
  final double? bufferValue;
  final Color bufferColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  
  _GradientCircularProgressPainter({
    required this.gradient,
    required this.value,
    required this.backgroundColor,
    this.bufferValue,
    required this.bufferColor,
    required this.strokeWidth,
    required this.strokeCap,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Buffer arc if needed
    if (bufferValue != null) {
      final bufferPaint = Paint()
        ..color = bufferColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap;
      
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * bufferValue!,
        false,
        bufferPaint,
      );
    }
    
    // Progress arc if determinate
    if (value != null) {
      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap;
      
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value!,
        false,
        progressPaint,
      );
    } else {
      // Indeterminate spinner animation would go here
      // This would require a separate AnimationController
      // For now, we'll just draw a full circle with the gradient
      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      
      canvas.drawCircle(center, radius, progressPaint);
    }
  }
  
  @override
  bool shouldRepaint(_GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
           oldDelegate.gradient != gradient ||
           oldDelegate.backgroundColor != backgroundColor ||
           oldDelegate.bufferValue != bufferValue ||
           oldDelegate.bufferColor != bufferColor ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.strokeCap != strokeCap;
  }
}