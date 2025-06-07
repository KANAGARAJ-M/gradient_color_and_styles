import 'dart:ui';

import 'package:flutter/material.dart';

import 'gradient_config.dart';

/// A text widget with a gradient fill
class GradientText extends StatelessWidget {
  /// The text to display
  final String text;

  /// The gradient configuration to use
  final GradientConfig gradient;

  /// The text style
  final TextStyle style;

  /// Text alignment
  final TextAlign textAlign;

  /// Text direction
  final TextDirection? textDirection;

  /// Maximum number of lines
  final int? maxLines;

  /// How text should handle overflow
  final TextOverflow overflow;

  /// Whether text should be selectable
  final bool selectable;

  /// Soft wrap behavior
  final bool softWrap;

  /// Text scaling factor
  final double? textScaleFactor;

  /// Text shadows (applies beneath the gradient)
  final List<Shadow>? shadows;

  /// Letter spacing
  final double? letterSpacing;

  /// Word spacing
  final double? wordSpacing;

  /// Text height
  final double? height;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Whether to animate the gradient
  final bool animateGradient;

  /// Duration for gradient animation
  final Duration animationDuration;

  /// Width of the text (for custom bounds)
  final double? width;

  /// Whether to apply a foreground blur effect
  final bool blurEffect;

  /// Blur sigma value when blurEffect is true
  final double blurSigma;

  /// Whether to use gradient for text shadow instead of solid color
  final bool gradientShadow;

  /// Shadow offset when using gradient shadow
  final Offset gradientShadowOffset;

  /// Creates a new gradient text widget
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
    this.textAlign = TextAlign.center,
    this.textDirection,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.selectable = false,
    this.softWrap = true,
    this.textScaleFactor,
    this.shadows,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.semanticsLabel,
    this.animateGradient = false,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.width,
    this.blurEffect = false,
    this.blurSigma = 1.0,
    this.gradientShadow = false,
    this.gradientShadowOffset = const Offset(2.0, 2.0),
  });

  @override
  Widget build(BuildContext context) {
    // Create base text style with appropriate properties
    final effectiveStyle = style.copyWith(
      color: Colors.white,
      letterSpacing: letterSpacing ?? style.letterSpacing,
      wordSpacing: wordSpacing ?? style.wordSpacing,
      height: height ?? style.height,
      shadows: gradientShadow ? null : shadows,
    );

    // Create text widget
    Widget textWidget = Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      semanticsLabel: semanticsLabel,
    );

    // Handle gradient shadow if enabled
    if (gradientShadow && shadows != null) {
      textWidget = Stack(
        children: [
          // Shadow layer with gradient
          Positioned(
            left: gradientShadowOffset.dx,
            top: gradientShadowOffset.dy,
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.toGradient().createShader(bounds),
              child: Text(
                text,
                style: effectiveStyle.copyWith(
                  color: Colors.white,
                  shadows: shadows,
                ),
                textAlign: textAlign,
                textDirection: textDirection,
                maxLines: maxLines,
                overflow: overflow,
                softWrap: softWrap,
                textScaleFactor: textScaleFactor,
              ),
            ),
          ),
          // Main text layer
          textWidget,
        ],
      );
    }

    // Apply blur effect if enabled
    if (blurEffect) {
      textWidget = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: textWidget,
      );
    }

    // Apply gradient with animation if needed
    if (animateGradient) {
      return _buildAnimatedGradient(textWidget);
    }

    // Apply basic gradient
    return ShaderMask(
      shaderCallback: (bounds) => gradient.toGradient().createShader(
        width != null ? Rect.fromLTWH(0, 0, width!, bounds.height) : bounds,
      ),
      child: selectable
          ? SelectableText(
              text,
              style: effectiveStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              maxLines: maxLines,
              textScaleFactor: textScaleFactor,
              semanticsLabel: semanticsLabel,
            )
          : textWidget,
    );
  }

  /// Builds an animated gradient effect
  Widget _buildAnimatedGradient(Widget textWidget) {
    return AnimatedSwitcher(
      duration: animationDuration,
      child: TweenAnimationBuilder<double>(
        key: ValueKey<int>(DateTime.now().millisecondsSinceEpoch % 1000),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: animationDuration,
        builder: (context, value, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              // Animate the gradient by shifting its positions
              final modifiedGradient = gradient.rotated(
                quarterTurns: (value * 4).toInt(),
              );
              return modifiedGradient.toGradient().createShader(
                width != null ? Rect.fromLTWH(0, 0, width!, bounds.height) : bounds,
              );
            },
            child: textWidget,
          );
        },
      ),
    );
  }

  /// Creates a heading text with gradient
  factory GradientText.heading(
    String text, {
    required GradientConfig gradient,
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.bold,
    TextAlign textAlign = TextAlign.center,
    List<Shadow>? shadows,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows,
      ),
      textAlign: textAlign,
    );
  }

  /// Creates a subtitle text with gradient
  factory GradientText.subtitle(
    String text, {
    required GradientConfig gradient,
    double fontSize = 18.0,
    FontWeight fontWeight = FontWeight.w500,
    TextAlign textAlign = TextAlign.center,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }

  /// Creates a text with gradient and shadow
  factory GradientText.withShadow(
    String text, {
    required GradientConfig gradient,
    required TextStyle style,
    Color shadowColor = Colors.black54,
    Offset shadowOffset = const Offset(1.0, 1.0),
    double shadowBlur = 2.0,
    TextAlign textAlign = TextAlign.center,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: style,
      shadows: [
        Shadow(
          color: shadowColor,
          offset: shadowOffset,
          blurRadius: shadowBlur,
        ),
      ],
      textAlign: textAlign,
    );
  }

  /// Creates an animated gradient text that changes over time
  factory GradientText.animated(
    String text, {
    required GradientConfig gradient,
    required TextStyle style,
    TextAlign textAlign = TextAlign.center,
    Duration animationDuration = const Duration(milliseconds: 3000),
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: style,
      textAlign: textAlign,
      animateGradient: true,
      animationDuration: animationDuration,
    );
  }

  /// Creates a gradient text that's selectable
  factory GradientText.selectable(
    String text, {
    required GradientConfig gradient,
    required TextStyle style,
    TextAlign textAlign = TextAlign.start,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: style,
      textAlign: textAlign,
      selectable: true,
    );
  }

  /// Creates a gradient text with a blur effect
  factory GradientText.blurred(
    String text, {
    required GradientConfig gradient,
    required TextStyle style,
    double blurSigma = 1.0,
    TextAlign textAlign = TextAlign.center,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: style,
      textAlign: textAlign,
      blurEffect: true,
      blurSigma: blurSigma,
    );
  }

  /// Creates a gradient text with a gradient shadow
  factory GradientText.gradientShadow(
    String text, {
    required GradientConfig gradient,
    required TextStyle style,
    Offset shadowOffset = const Offset(2.0, 2.0),
    List<Shadow> shadows = const [Shadow(color: Colors.black45, blurRadius: 2.0)],
    TextAlign textAlign = TextAlign.center,
  }) {
    return GradientText(
      text,
      gradient: gradient,
      style: style,
      textAlign: textAlign,
      gradientShadow: true,
      gradientShadowOffset: shadowOffset,
      shadows: shadows,
    );
  }
}