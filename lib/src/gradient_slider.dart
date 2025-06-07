import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A slider with gradient track and thumb
class GradientSlider extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The current value of the slider
  final double value;
  
  /// Callback when the value changes
  final ValueChanged<double> onChanged;
  
  /// The minimum value of the slider
  final double min;
  
  /// The maximum value of the slider
  final double max;
  
  /// The number of divisions (null for continuous)
  final int? divisions;
  
  /// Label to show for the current value
  final String? label;
  
  /// Creates a new gradient slider
  const GradientSlider({
    super.key,
    required this.gradient,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4.0,
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor: Colors.white,
        thumbShape: _GradientThumbShape(gradient: gradient),
        overlayColor: Colors.white.withOpacity(0.2),
        valueIndicatorColor: Colors.white,
        valueIndicatorTextStyle: const TextStyle(color: Colors.black),
      ),
      child: Stack(
        children: [
          Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 4.0,
                  width: (value - min) / (max - min) * (MediaQuery.of(context).size.width - 24 - 30),
                  decoration: BoxDecoration(
                    gradient: gradient.toGradient(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom thumb shape with gradient
class _GradientThumbShape extends SliderComponentShape {
  final GradientConfig gradient;
  final double radius = 10.0;

  const _GradientThumbShape({
    required this.gradient,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    
    final Paint fillPaint = Paint()
      ..shader = gradient.toGradient().createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;
      
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, borderPaint);
  }
}