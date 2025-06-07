import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A button with a gradient background
class GradientButton extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// Text to display in the button
  final String text;
  
  /// Text style for the button text
  final TextStyle? textStyle;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// Callback when the button is long-pressed
  final VoidCallback? onLongPress;
  
  /// Width of the button
  final double? width;
  
  /// Height of the button
  final double? height;
  
  /// Border radius for the button
  final BorderRadius? borderRadius;
  
  /// Padding inside the button
  final EdgeInsetsGeometry padding;
  
  /// Icon to display alongside text (optional)
  final IconData? icon;
  
  /// Size of the icon
  final double iconSize;
  
  /// Spacing between icon and text
  final double iconSpacing;
  
  /// Position of the icon relative to text
  final IconPosition iconPosition;
  
  /// Whether the button should display a loading indicator
  final bool isLoading;
  
  /// Color of the loading indicator
  final Color loadingColor;
  
  /// Size of the loading indicator
  final double loadingSize;
  
  /// Elevation/shadow for the button
  final double elevation;
  
  /// Color of the shadow
  final Color shadowColor;
  
  /// Border around the button
  final Border? border;
  
  /// Background color when disabled
  final Color disabledColor;
  
  /// Text color when disabled
  final Color disabledTextColor;
  
  /// Gradient to use when disabled (takes precedence over disabledColor)
  final GradientConfig? disabledGradient;
  
  /// Splash color when button is tapped
  final Color? splashColor;
  
  /// Highlight color when button is pressed
  final Color? highlightColor;
  
  /// Alignment of content within button
  final AlignmentGeometry alignment;
  
  /// Scale factor when pressed
  final double pressedScale;
  
  /// Whether to animate the scale on press
  final bool animateOnPress;
  
  /// Duration for animations
  final Duration animationDuration;
  
  /// Shape of the button (if null, uses borderRadius)
  final ShapeBorder? shape;

  /// Creates a new gradient button
  const GradientButton({
    super.key,
    required this.gradient,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.textStyle,
    this.width,
    this.height,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.icon,
    this.iconSize = 24.0,
    this.iconSpacing = 8.0,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.loadingColor = Colors.white,
    this.loadingSize = 24.0,
    this.elevation = 0.0,
    this.shadowColor = Colors.black,
    this.border,
    this.disabledColor = Colors.grey,
    this.disabledTextColor = Colors.white70,
    this.disabledGradient,
    this.splashColor,
    this.highlightColor,
    this.alignment = Alignment.center,
    this.pressedScale = 0.98,
    this.animateOnPress = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.shape,
  });

  bool get _isDisabled => onPressed == null && onLongPress == null;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8);
    final effectiveShape = shape ?? RoundedRectangleBorder(borderRadius: effectiveBorderRadius);
    
    // Create button content
    Widget buttonContent = _buildButtonContent();
    
    // Apply gradient container
    Widget button = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: _isDisabled 
            ? disabledGradient?.toGradient() ?? LinearGradient(colors: [disabledColor, disabledColor])
            : gradient.toGradient(),
        borderRadius: shape == null ? effectiveBorderRadius : null,
        border: border,
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 2,
            offset: Offset(0, elevation / 2),
          ),
        ] : null,
      ),
      alignment: alignment,
      child: buttonContent,
    );
    
    // Wrap with ink effect if not disabled
    if (!_isDisabled) {
      button = Material(
        color: Colors.transparent,
        shape: effectiveShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          onLongPress: isLoading ? null : onLongPress,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: button,
        ),
      );
      
      // Add scale animation if enabled
      if (animateOnPress) {
        button = _addScaleAnimation(button);
      }
    }
    
    return button;
  }

  Widget _buildButtonContent() {
    // Show loading indicator if in loading state
    if (isLoading) {
      return SizedBox(
        width: loadingSize,
        height: loadingSize,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          strokeWidth: 2.0,
        ),
      );
    }
    
    // If there's an icon, show it alongside text
    if (icon != null) {
      final iconWidget = Icon(
        icon,
        size: iconSize,
        color: _isDisabled 
            ? disabledTextColor 
            : (textStyle?.color ?? Colors.white),
      );
      
      final textWidget = Text(
        text,
        style: _isDisabled
            ? TextStyle(color: disabledTextColor, fontWeight: FontWeight.bold)
            : textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
      
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconPosition == IconPosition.left
            ? [
                iconWidget,
                SizedBox(width: iconSpacing),
                textWidget,
              ]
            : [
                textWidget,
                SizedBox(width: iconSpacing),
                iconWidget,
              ],
      );
    }
    
    // Otherwise just show text
    return Text(
      text,
      style: _isDisabled
          ? TextStyle(color: disabledTextColor, fontWeight: FontWeight.bold)
          : textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
  
  Widget _addScaleAnimation(Widget child) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => setState(() {}),
          onTapUp: (_) => setState(() {}),
          onTapCancel: () => setState(() {}),
          child: AnimatedScale(
            scale: 1.0,
            duration: animationDuration,
            child: child,
          ),
        );
      },
    );
  }
  
  /// Creates a rounded gradient button with elevation
  factory GradientButton.elevated({
    required GradientConfig gradient,
    required String text,
    required VoidCallback? onPressed,
    double elevation = 4.0,
    TextStyle? textStyle,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return GradientButton(
      gradient: gradient,
      text: text,
      onPressed: onPressed,
      textStyle: textStyle,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(30),
      padding: padding,
      elevation: elevation,
    );
  }
  
  /// Creates an outlined gradient button
  factory GradientButton.outlined({
    required GradientConfig gradient,
    required String text,
    required VoidCallback? onPressed,
    TextStyle? textStyle,
    double borderWidth = 2.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) {
    return GradientButton(
      gradient: gradient,
      text: text,
      onPressed: onPressed,
      textStyle: textStyle,
      padding: padding,
      border: Border.all(
        width: borderWidth,
        color: gradient.colors.first, // Use first color from gradient for border
      ),
    );
  }
  
  /// Creates an icon button with gradient
  factory GradientButton.icon({
    required GradientConfig gradient,
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    TextStyle? textStyle,
    IconPosition iconPosition = IconPosition.left,
    double iconSize = 20.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) {
    return GradientButton(
      gradient: gradient,
      text: text,
      onPressed: onPressed,
      textStyle: textStyle,
      icon: icon,
      iconSize: iconSize,
      iconPosition: iconPosition,
      padding: padding,
    );
  }
}

/// Position of the icon relative to text
enum IconPosition {
  /// Icon appears before text
  left,
  
  /// Icon appears after text
  right,
}