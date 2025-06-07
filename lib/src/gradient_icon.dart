import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// An icon widget with a gradient fill
class GradientIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// Size of the icon
  final double size;
  
  /// Semantic label for the icon
  final String? semanticLabel;
  
  /// Text direction for the icon
  final TextDirection? textDirection;
  
  /// Whether the icon should be mirrored in right-to-left environments
  final bool? matchTextDirection;
  
  /// Base color of the icon (used with the gradient)
  final Color color;
  
  /// Optional shadow for the icon
  final Shadow? shadow;
  
  /// Callback when the icon is tapped
  final VoidCallback? onTap;
  
  /// Callback when the icon is long-pressed
  final VoidCallback? onLongPress;
  
  /// Whether to show a splash effect when tapped
  final bool enableFeedback;
  
  /// Splash color for tap effect
  final Color? splashColor;
  
  /// Highlight color when pressed
  final Color? highlightColor;
  
  /// Optional tooltip text
  final String? tooltip;
  
  /// Optional badge to show on the icon
  final Widget? badge;
  
  /// Position of the badge
  final Alignment badgeAlignment;
  
  /// Padding for the badge
  final EdgeInsetsGeometry badgePadding;
  
  /// Whether to animate when hovered or pressed
  final bool animateOnInteraction;
  
  /// Scale factor when hovered or pressed
  final double hoverScale;
  
  /// Duration for animations
  final Duration animationDuration;
  
  /// Icon style - filled or outlined
  final IconStyle iconStyle;
  
  /// Thickness of outlined icons (when using IconStyle.outlined)
  final double outlineThickness;

  /// Creates a new gradient icon
  const GradientIcon({
    super.key,
    required this.icon,
    required this.gradient,
    this.size = 24.0,
    this.semanticLabel,
    this.textDirection,
    this.matchTextDirection,
    this.color = Colors.white,
    this.shadow,
    this.onTap,
    this.onLongPress,
    this.enableFeedback = true,
    this.splashColor,
    this.highlightColor,
    this.tooltip,
    this.badge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.animateOnInteraction = false,
    this.hoverScale = 1.1,
    this.animationDuration = const Duration(milliseconds: 150),
    this.iconStyle = IconStyle.filled,
    this.outlineThickness = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    // Base icon with gradient
    Widget iconWidget = ShaderMask(
      shaderCallback: (bounds) => gradient.toGradient().createShader(bounds),
      child: Icon(
        icon,
        color: color,
        size: size,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
        shadows: shadow != null ? [shadow!] : null,
      ),
    );
    
    // For outlined style, we need a different approach
    if (iconStyle == IconStyle.outlined) {
      iconWidget = ShaderMask(
        shaderCallback: (bounds) => gradient.toGradient().createShader(bounds),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: size + outlineThickness,
              semanticLabel: semanticLabel,
              textDirection: textDirection,
            ),
            Icon(
              icon,
              color: Colors.transparent,
              size: size,
              semanticLabel: semanticLabel,
              textDirection: textDirection,
            ),
          ],
        ),
      );
    }
    
    // Add shadow if specified
    if (shadow != null) {
      iconWidget = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadow!.color,
              blurRadius: shadow!.blurRadius,
              offset: shadow!.offset,
            ),
          ],
        ),
        child: iconWidget,
      );
    }
    
    // Add interactivity if needed
    if (onTap != null || onLongPress != null) {
      final interactiveIcon = tooltip != null
          ? Tooltip(
              message: tooltip!,
              child: iconWidget,
            )
          : iconWidget;
      
      iconWidget = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: BorderRadius.circular(size / 2),
        enableFeedback: enableFeedback,
        child: interactiveIcon,
      );
      
      // Add animation if enabled
      if (animateOnInteraction) {
        iconWidget = _addInteractionEffect(iconWidget);
      }
    } else if (tooltip != null) {
      // Add tooltip even if not interactive
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }
    
    // Add badge if provided
    if (badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
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
    
    return iconWidget;
  }
  
  /// Adds hover and press animations
  Widget _addInteractionEffect(Widget child) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isActive = false;
        
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
  
  /// Creates a notification badge icon
  factory GradientIcon.withBadge({
    required IconData icon, 
    required GradientConfig gradient,
    required String badgeText,
    double size = 24.0,
    Color badgeColor = Colors.red,
    Color badgeTextColor = Colors.white,
    VoidCallback? onTap,
  }) {
    final badge = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Center(
        child: Text(
          badgeText,
          style: TextStyle(
            color: badgeTextColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    
    return GradientIcon(
      icon: icon,
      gradient: gradient,
      size: size,
      onTap: onTap,
      badge: badge,
      badgeAlignment: Alignment.topRight,
      badgePadding: const EdgeInsets.only(left: 12, bottom: 12),
    );
  }
  
  /// Creates an animated gradient icon
  factory GradientIcon.animated({
    required IconData icon,
    required GradientConfig gradient,
    double size = 24.0,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return GradientIcon(
      icon: icon,
      gradient: gradient,
      size: size,
      animateOnInteraction: true,
      animationDuration: duration,
      hoverScale: 1.2,
    );
  }
  
  /// Creates an outlined gradient icon
  factory GradientIcon.outlined({
    required IconData icon,
    required GradientConfig gradient,
    double size = 24.0,
    double outlineThickness = 2.0,
  }) {
    return GradientIcon(
      icon: icon,
      gradient: gradient,
      size: size,
      iconStyle: IconStyle.outlined,
      outlineThickness: outlineThickness,
    );
  }
}

/// Style options for the gradient icon
enum IconStyle {
  /// Filled icon (default)
  filled,
  
  /// Outlined icon
  outlined,
}