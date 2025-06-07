import 'package:flutter/material.dart';
import 'gradient_config.dart';

/// An AppBar with a gradient background
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title of the app bar
  final Widget title;
  
  /// The gradient configuration to use
  final GradientConfig gradient;
  
  /// Actions to display in the app bar
  final List<Widget>? actions;
  
  /// Leading widget for the app bar
  final Widget? leading;
  
  /// Whether to show the back button
  final bool automaticallyImplyLeading;
  
  /// Elevation of the app bar
  final double elevation;
  
  /// Whether to center the title
  final bool centerTitle;
  
  /// Bottom widget for the app bar (e.g. TabBar)
  final PreferredSizeWidget? bottom;
  
  /// Spacing around the title
  final double titleSpacing;
  
  /// Height of the toolbar
  final double toolbarHeight;
  
  /// Padding for the title
  final EdgeInsetsGeometry titlePadding;
  
  /// Text style for the title
  final TextStyle? titleTextStyle;
  
  /// Icon theme for the app bar
  final IconThemeData? iconTheme;
  
  /// Icon theme for actions
  final IconThemeData? actionsIconTheme;
  
  /// Background color for gradient container
  final Color? backgroundColor;
  
  /// Shadow color for the app bar
  final Color? shadowColor;
  
  /// Shape of the app bar
  final ShapeBorder? shape;
  
  /// Creates a new gradient app bar
  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 4.0,
    required this.centerTitle,
    this.bottom,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarHeight = kToolbarHeight,
    this.titlePadding = EdgeInsets.zero,
    this.titleTextStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.backgroundColor,
    this.shadowColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      centerTitle: centerTitle,
      bottom: bottom,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      titleTextStyle: titleTextStyle,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      shadowColor: shadowColor,
      shape: shape,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient.toGradient(),
          color: backgroundColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}