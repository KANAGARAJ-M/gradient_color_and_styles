import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A tab bar with gradient background
class GradientTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// The controller for the tabs
  final TabController controller;
  
  /// The tabs to display
  final List<Widget> tabs;
  
  /// The indicator color
  final Color indicatorColor;
  
  /// The indicator weight
  final double indicatorWeight;
  
  /// The padding for the tab bar
  final EdgeInsetsGeometry padding;
  
  /// Whether to add a divider at the bottom
  final bool showDivider;
  
  /// The divider color
  final Color dividerColor;
  
  /// The divider thickness
  final double dividerThickness;
  
  /// The label color for selected tabs
  final Color labelColor;
  
  /// The label color for unselected tabs
  final Color unselectedLabelColor;
  
  /// Text style for selected tab labels
  final TextStyle? labelStyle;
  
  /// Text style for unselected tab labels
  final TextStyle? unselectedLabelStyle;
  
  /// Whether the tabs should be distributed evenly across the tab bar
  final bool isScrollable;
  
  /// The indicator padding
  final EdgeInsetsGeometry indicatorPadding;
  
  /// The indicator decoration (overrides indicatorColor if provided)
  final Decoration? indicator;
  
  /// Whether to use a gradient for the indicator instead of a solid color
  final bool useGradientIndicator;
  
  /// Gradient for the indicator (if useGradientIndicator is true)
  final GradientConfig? indicatorGradient;
  
  /// The shape of the indicator
  final TabBarIndicatorSize indicatorSize;
  
  /// How tabs should be aligned horizontally
  final TabAlignment tabAlignment;
  
  /// Overlay color for the ripple effect when tapped
  final MaterialStateProperty<Color?>? overlayColor;
  
  /// The gap between tabs
  final double? tabGap;
  
  /// Duration for the animation when switching tabs
  final Duration? animationDuration;
  
  /// Curve for the animation when switching tabs
  final Curve animationCurve;
  
  /// Elevation/shadow for the tab bar
  final double elevation;
  
  /// Shadow color for the tab bar
  final Color shadowColor;
  
  /// Height of the tab bar
  final double height;
  
  /// Background color behind the gradient
  final Color? backgroundColor;
  
  /// Border radius for the tab bar
  final BorderRadius? borderRadius;
  
  /// Creates a new gradient tab bar
  const GradientTabBar({
    super.key,
    required this.gradient,
    required this.controller,
    required this.tabs,
    this.indicatorColor = Colors.white,
    this.indicatorWeight = 2.0,
    this.padding = const EdgeInsets.all(0),
    this.showDivider = true,
    this.dividerColor = Colors.white24,
    this.dividerThickness = 0.5,
    this.labelColor = Colors.white,
    this.unselectedLabelColor = Colors.white70,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.isScrollable = false,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.useGradientIndicator = false,
    this.indicatorGradient,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.tabAlignment = TabAlignment.start,
    this.overlayColor,
    this.tabGap,
    this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.elevation = 0.0,
    this.shadowColor = Colors.black54,
    this.height = kToolbarHeight,
    this.backgroundColor,
    this.borderRadius,
  }) : assert(
         !useGradientIndicator || indicatorGradient != null,
         'If useGradientIndicator is true, indicatorGradient must be provided'
       );

  @override
  Widget build(BuildContext context) {
    // Create indicator decoration if using gradient indicator
    final effectiveIndicator = useGradientIndicator
        ? _createGradientIndicator(context)
        : indicator;
    
    // Create the tab bar with gradient background
    Widget tabBar = Container(
      decoration: BoxDecoration(
        gradient: gradient.toGradient(),
        color: backgroundColor,
        borderRadius: borderRadius,
        border: showDivider ? Border(
          bottom: BorderSide(
            color: dividerColor,
            width: dividerThickness,
          ),
        ) : null,
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: elevation / 2,
            offset: Offset(0, elevation / 3),
          ),
        ] : null,
      ),
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicatorColor: indicatorColor,
        indicatorWeight: indicatorWeight,
        padding: padding,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        isScrollable: isScrollable,
        indicatorPadding: indicatorPadding,
        indicator: effectiveIndicator,
        indicatorSize: indicatorSize,
        tabAlignment: tabAlignment,
        overlayColor: overlayColor,
        labelPadding: tabGap != null 
            ? EdgeInsets.symmetric(horizontal: tabGap! / 2) 
            : null,
        dividerColor: Colors.transparent, // We handle divider ourselves
      ),
    );
    
    return tabBar;
  }

  /// Creates a gradient indicator decoration
  Decoration _createGradientIndicator(BuildContext context) {
    return UnderlineTabIndicator(
      borderSide: BorderSide(
        width: indicatorWeight,
        color: Colors.transparent,
      ),
      insets: indicatorPadding as EdgeInsets,
      borderRadius: null,
      gradient: indicatorGradient!.toGradient(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
  
  /// Creates a tab bar with bottom dots as indicators
  factory GradientTabBar.dots({
    required GradientConfig gradient,
    required TabController controller,
    required List<Widget> tabs,
    Color dotColor = Colors.white,
    double dotSize = 8.0,
    Color labelColor = Colors.white,
    Color unselectedLabelColor = Colors.white70,
  }) {
    return GradientTabBar(
      gradient: gradient,
      controller: controller,
      tabs: tabs,
      showDivider: false,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      indicator: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 8.0),
    );
  }
  
  /// Creates a tab bar with a pill-shaped indicator
  factory GradientTabBar.pill({
    required GradientConfig gradient,
    required TabController controller,
    required List<Widget> tabs,
    Color indicatorColor = Colors.white,
    GradientConfig? indicatorGradient,
    Color labelColor = Colors.white,
    Color unselectedLabelColor = Colors.white70,
    double indicatorHeight = 36.0,
    double borderRadius = 18.0,
  }) {
    return GradientTabBar(
      gradient: gradient,
      controller: controller,
      tabs: tabs,
      showDivider: false,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      useGradientIndicator: indicatorGradient != null,
      indicatorGradient: indicatorGradient,
      indicator: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    );
  }
  
  /// Creates a tab bar with material design 3 style
  factory GradientTabBar.material3({
    required GradientConfig gradient,
    required TabController controller,
    required List<Widget> tabs,
    Color indicatorColor = Colors.white,
    Color labelColor = Colors.white,
    Color unselectedLabelColor = Colors.white70,
    BorderRadius? borderRadius,
  }) {
    return GradientTabBar(
      gradient: gradient,
      controller: controller,
      tabs: tabs,
      indicatorColor: indicatorColor,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      showDivider: false,
      elevation: 2.0,
      borderRadius: borderRadius ?? BorderRadius.circular(28.0),
      indicatorSize: TabBarIndicatorSize.label,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }
}

/// Custom underline tab indicator that supports gradients
class UnderlineTabIndicator extends Decoration {
  /// The border side for the underline
  final BorderSide borderSide;
  
  /// The insets for the indicator
  final EdgeInsets insets;
  
  /// The border radius for the indicator
  final BorderRadius? borderRadius;
  
  /// The gradient for the indicator
  final Gradient? gradient;

  /// Creates a new underline tab indicator
  const UnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.borderRadius,
    this.gradient,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final UnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final Paint paint = Paint();
    
    if (decoration.gradient != null) {
      paint.shader = decoration.gradient!.createShader(indicator);
    } else {
      paint.color = decoration.borderSide.color;
    }
    
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = decoration.borderSide.width;
    
    if (decoration.borderRadius != null) {
      // Draw rounded rectangle
      canvas.drawRRect(
        RRect.fromRectAndRadius(indicator, decoration.borderRadius!.topLeft),
        paint,
      );
    } else {
      // Draw regular rectangle
      canvas.drawRect(indicator, paint);
    }
  }

  Rect _indicatorRectFor(Rect rect, TextDirection? textDirection) {
    final Rect indicator = rect.deflate(decoration.insets.horizontal / 2);
    // Return a rect that is centered and has the specified height
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - decoration.borderSide.width,
      indicator.width,
      decoration.borderSide.width,
    );
  }
}