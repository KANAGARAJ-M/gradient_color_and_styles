import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// A bottom navigation bar with gradient background
class GradientBottomNavBar extends StatelessWidget {
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// Items to display in the bottom navigation bar
  final List<BottomNavigationBarItem> items;
  
  /// Current active index
  final int currentIndex;
  
  /// Callback when an item is tapped
  final Function(int) onTap;
  
  /// Type of bottom navigation bar
  final BottomNavigationBarType type;
  
  /// Whether to show the labels
  final bool showLabels;
  
  /// Selected item color
  final Color selectedItemColor;
  
  /// Unselected item color
  final Color unselectedItemColor;
  
  /// Elevation of the navigation bar
  final double elevation;
  
  /// Shadow color for the navigation bar
  final Color? shadowColor;
  
  /// Selected item label style
  final TextStyle? selectedLabelStyle;
  
  /// Unselected item label style
  final TextStyle? unselectedLabelStyle;
  
  /// Size of the navigation bar icons
  final double iconSize;
  
  /// Padding around the navigation bar
  final EdgeInsetsGeometry padding;
  
  /// Whether to show a notch for a FloatingActionButton
  final bool hasNotch;
  
  /// The shape of the notch if hasNotch is true
  final NotchedShape? notchedShape;
  
  /// Border radius for the navigation bar
  final BorderRadius? borderRadius;
  
  /// Optional top border for the navigation bar
  final BorderSide? topBorder;
  
  /// Duration for selection change animations
  final Duration animationDuration;
  
  /// Curve for selection change animations
  final Curve animationCurve;
  
  /// Whether to use a custom indicator for selected items
  final bool useIndicator;
  
  /// Color of the custom indicator (if useIndicator is true)
  final Color? indicatorColor;
  
  /// Height of the custom indicator (if useIndicator is true)
  final double indicatorHeight;
  
  /// Width of the custom indicator (if useIndicator is true)
  /// If null, the indicator will match the item width
  final double? indicatorWidth;
  
  /// Shape of the custom indicator (if useIndicator is true)
  final BoxShape indicatorShape;
  
  /// Border radius of the custom indicator when shape is rectangle
  final BorderRadius? indicatorBorderRadius;
  
  /// Whether the indicator should have a gradient
  final bool indicatorHasGradient;
  
  /// Optional gradient for the indicator (if indicatorHasGradient is true)
  final GradientConfig? indicatorGradient;
  
  /// Item spacing (horizontal spacing between items)
  final double itemSpacing;
  
  /// Creates a new gradient bottom navigation bar
  const GradientBottomNavBar({
    super.key,
    required this.gradient,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.type = BottomNavigationBarType.fixed,
    this.showLabels = true,
    this.selectedItemColor = Colors.white,
    this.unselectedItemColor = Colors.white60,
    this.elevation = 0,
    this.shadowColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.iconSize = 24.0,
    this.padding = EdgeInsets.zero,
    this.hasNotch = false,
    this.notchedShape,
    this.borderRadius,
    this.topBorder,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.useIndicator = false,
    this.indicatorColor,
    this.indicatorHeight = 3.0,
    this.indicatorWidth,
    this.indicatorShape = BoxShape.rectangle,
    this.indicatorBorderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.indicatorHasGradient = false,
    this.indicatorGradient,
    this.itemSpacing = 0.0,
  }) : assert(!useIndicator || indicatorColor != null || indicatorHasGradient,
              'If useIndicator is true, either indicatorColor or indicatorHasGradient must be provided'),
       assert(!indicatorHasGradient || indicatorGradient != null, 
              'If indicatorHasGradient is true, indicatorGradient must be provided');

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      type: type,
      backgroundColor: Colors.transparent,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      elevation: 0, // We handle elevation ourselves with the Container
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      iconSize: iconSize,
    );
    
    // Create the container with gradient background
    Widget result = Container(
      decoration: BoxDecoration(
        gradient: gradient.toGradient(),
        borderRadius: borderRadius,
        boxShadow: elevation > 0 
            ? [
                BoxShadow(
                  color: (shadowColor ?? Colors.black.withOpacity(0.3)),
                  blurRadius: elevation,
                  spreadRadius: elevation / 2,
                  offset: Offset(0, -elevation / 2),
                ),
              ] 
            : null,
        border: topBorder != null
            ? Border(top: topBorder!)
            : null,
      ),
      padding: padding,
      child: bottomNavBar,
    );
    
    // Add notch if required
    if (hasNotch && notchedShape != null) {
      result = ClipPath(
        clipper: _BottomNavBarClipper(
          shape: notchedShape!,
          notchMargin: 8.0,
        ),
        child: result,
      );
    }
    
    // Add custom indicator if required
    if (useIndicator) {
      result = Stack(
        alignment: Alignment.bottomCenter,
        children: [
          result,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildIndicator(context),
          ),
        ],
      );
    }
    
    return result;
  }
  
  /// Builds the custom indicator for the selected item
  Widget _buildIndicator(BuildContext context) {
    // Calculate the indicator position based on currentIndex
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - padding.horizontal - (items.length - 1) * itemSpacing) / items.length;
    
    final indicatorOffset = currentIndex * (itemWidth + itemSpacing) + (itemWidth - (indicatorWidth ?? itemWidth)) / 2;
    
    return AnimatedPositioned(
      duration: animationDuration,
      curve: animationCurve,
      left: indicatorOffset + padding.resolve(TextDirection.ltr).left,
      bottom: 0,
      child: Container(
        width: indicatorWidth ?? itemWidth,
        height: indicatorHeight,
        decoration: BoxDecoration(
          color: indicatorHasGradient ? null : indicatorColor,
          gradient: indicatorHasGradient ? indicatorGradient?.toGradient() : null,
          shape: indicatorShape,
          borderRadius: indicatorShape == BoxShape.rectangle ? indicatorBorderRadius : null,
        ),
      ),
    );
  }
  
  /// Creates a material-style bottom navigation bar with gradient
  factory GradientBottomNavBar.material({
    required GradientConfig gradient,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
    Color selectedItemColor = Colors.white,
    Color unselectedItemColor = Colors.white70,
    bool showLabels = true,
  }) {
    return GradientBottomNavBar(
      gradient: gradient,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showLabels: showLabels,
      elevation: 8.0,
      shadowColor: Colors.black.withOpacity(0.2),
    );
  }
  
  /// Creates a bottom navigation bar with a pill-shaped indicator
  factory GradientBottomNavBar.withPillIndicator({
    required GradientConfig gradient,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
    Color selectedItemColor = Colors.white,
    Color unselectedItemColor = Colors.white70,
    Color indicatorColor = Colors.white,
    GradientConfig? indicatorGradient,
  }) {
    return GradientBottomNavBar(
      gradient: gradient,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showLabels: true,
      useIndicator: true,
      indicatorColor: indicatorColor,
      indicatorHeight: 5.0,
      indicatorWidth: 40.0,
      indicatorBorderRadius: BorderRadius.circular(10),
      indicatorHasGradient: indicatorGradient != null,
      indicatorGradient: indicatorGradient,
    );
  }
  
  /// Creates a notched bottom navigation bar for FABs
  factory GradientBottomNavBar.notched({
    required GradientConfig gradient,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
    Color selectedItemColor = Colors.white,
    Color unselectedItemColor = Colors.white70,
  }) {
    return GradientBottomNavBar(
      gradient: gradient,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showLabels: true,
      hasNotch: true,
      notchedShape: const CircularNotchedRectangle(),
      elevation: 12.0,
    );
  }
}

/// Custom clipper for notched bottom navigation bar
class _BottomNavBarClipper extends CustomClipper<Path> {
  final NotchedShape shape;
  final double notchMargin;

  _BottomNavBarClipper({
    required this.shape,
    required this.notchMargin,
  });

  @override
  Path getClip(Size size) {
    // Get the host shape (the full navbar shape)
    final host = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Calculate the position of the notch/FAB
    final fabSize = Size(56, 56); // Standard FAB size
    final fabOffset = Offset(
      size.width / 2 - fabSize.width / 2,
      -fabSize.height / 2,
    );
    final guest = Rect.fromLTWH(
      fabOffset.dx,
      fabOffset.dy,
      fabSize.width,
      fabSize.height,
    );

    // Create the notched path
    return shape.getOuterPath(host, guest);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}