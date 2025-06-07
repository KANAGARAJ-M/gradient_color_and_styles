import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A circular avatar with gradient background
class GradientAvatar extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The radius of the avatar
  final double radius;
  
  /// The child widget (usually text or icon)
  final Widget? child;
  
  /// Image to display in the avatar
  final ImageProvider? backgroundImage;
  
  /// Image to display in the foreground (overlaid on the background)
  final ImageProvider? foregroundImage;
  
  /// Border width for the avatar
  final double borderWidth;
  
  /// Border color for the avatar
  final Color? borderColor;
  
  /// Gradient for the border (takes precedence over borderColor if provided)
  final GradientConfig? borderGradient;
  
  /// Shadow elevation for the avatar
  final double elevation;
  
  /// Shadow color for the avatar
  final Color shadowColor;
  
  /// Background color when no gradient is applied
  final Color? backgroundColor;
  
  /// Optional badge to show on the avatar (like notification count)
  final Widget? badge;
  
  /// Position of the badge
  final AlignmentGeometry badgeAlignment;
  
  /// Padding for the badge
  final EdgeInsetsGeometry badgePadding;
  
  /// Shape of the avatar (circular by default)
  final BoxShape shape;
  
  /// Border radius when shape is rectangle
  final BorderRadius? borderRadius;
  
  /// Callback when the avatar is tapped
  final VoidCallback? onTap;
  
  /// Placeholder to show when no image is available
  final Widget? placeholder;
  
  /// Error widget to show when image fails to load
  final Widget? errorWidget;
  
  /// Creates a new gradient avatar
  const GradientAvatar({
    super.key,
    required this.gradient,
    this.radius = 20.0,
    this.child,
    this.backgroundImage,
    this.foregroundImage,
    this.borderWidth = 0.0,
    this.borderColor,
    this.borderGradient,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
    this.backgroundColor,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.onTap,
    this.placeholder,
    this.errorWidget,
  }) : assert(shape == BoxShape.circle || shape == BoxShape.rectangle && borderRadius != null, 
             'borderRadius must be provided when shape is BoxShape.rectangle');

  @override
  Widget build(BuildContext context) {
    // Create the border decoration
    BoxBorder? border;
    if (borderWidth > 0) {
      if (borderGradient != null) {
        // Create a gradient border
        border = _GradientBorder(
          gradient: borderGradient!.toGradient(),
          width: borderWidth,
        );
      } else if (borderColor != null) {
        // Create a solid color border
        border = Border.all(
          color: borderColor!,
          width: borderWidth,
        );
      }
    }

    // Create the base avatar
    Widget avatarWidget = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        gradient: gradient.toGradient(),
        color: backgroundColor,
        border: border,
        boxShadow: elevation > 0 
            ? [
                BoxShadow(
                  color: shadowColor.withOpacity(0.5),
                  blurRadius: elevation,
                  spreadRadius: elevation / 2,
                ),
              ] 
            : null,
      ),
      child: _buildAvatarContent(),
    );
    
    // Add tap handler if provided
    if (onTap != null) {
      avatarWidget = InkWell(
        onTap: onTap,
        customBorder: shape == BoxShape.circle 
            ? const CircleBorder() 
            : RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.zero),
        child: avatarWidget,
      );
    }
    
    // Add badge if provided
    if (badge != null) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned.fill(
            child: Align(
              alignment: badgeAlignment,
              child: Padding(
                padding: badgePadding,
                child: badge,
              ),
            ),
          ),
        ],
      );
    }
    
    return avatarWidget;
  }
  
  /// Builds the content of the avatar (image, foreground, child)
  Widget _buildAvatarContent() {
    if (backgroundImage != null) {
      // If we have a background image
      Widget content = CircleAvatar(
        radius: radius - borderWidth,
        backgroundImage: backgroundImage,
        backgroundColor: Colors.transparent,
        foregroundImage: foregroundImage,
        child: foregroundImage == null ? child : null,
      );
      
      // Apply proper clipping based on shape
      if (shape == BoxShape.rectangle) {
        content = ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: content,
        );
      }
      
      return content;
    } else if (foregroundImage != null) {
      // If we have only a foreground image
      Widget content = CircleAvatar(
        radius: radius - borderWidth,
        backgroundColor: Colors.transparent,
        foregroundImage: foregroundImage,
        child: child,
      );
      
      // Apply proper clipping based on shape
      if (shape == BoxShape.rectangle) {
        content = ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: content,
        );
      }
      
      return content;
    } else if (child != null) {
      // If we have only a child widget
      return Center(child: child);
    } else if (placeholder != null) {
      // If we have a placeholder for empty state
      return Center(child: placeholder);
    }
    
    // Default empty state
    return const SizedBox();
  }
}

/// Custom border class for gradient borders
class _GradientBorder extends BoxBorder {
  final Gradient gradient;
  final double width;

  const _GradientBorder({
    required this.gradient,
    required this.width,
  });
  
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  BorderSide get top => BorderSide(width: width, color: Colors.transparent);

  BorderSide get bottom => BorderSide(width: width, color: Colors.transparent);

  BorderSide get left => BorderSide(width: width, color: Colors.transparent);

  BorderSide get right => BorderSide(width: width, color: Colors.transparent);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    
    if (shape == BoxShape.circle) {
      path.addOval(rect);
    } else {
      path.addRRect(
        borderRadius?.toRRect(rect) ?? RRect.fromRectAndRadius(rect, Radius.zero)
      );
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  _GradientBorder scale(double t) {
    return _GradientBorder(
      gradient: gradient,
      width: width * t,
    );
  }
}