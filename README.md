# Gradient Colors and Styles

A comprehensive Flutter package for creating beautiful gradient styles across your entire application with highly customizable widgets and gradient configurations.

## Features

### Core Components
- Flexible gradient configuration system via `GradientConfig`
- Multiple gradient types (linear, radial, sweep)
- Support for multiple colors with customizable positions
- Preset gradient library with ready-to-use configurations
- Gradient transformation methods (reverse, rotate, tint, brightness/saturation adjustment)

### Containers and Surfaces
- `GradientContainer` - Containers with gradient backgrounds and interactive effects
- `GradientCard` - Card widgets with gradient styling and elevation
- `GradientDivider` - Horizontal, vertical, and dashed dividers with gradient coloring

### Buttons and Controls
- `GradientButton` - Buttons with gradient backgrounds, icons, and loading states
- `GradientFAB` - Floating Action Buttons with gradient styling
- `GradientToggle` - Toggle switches with gradient when active
- `GradientSlider` - Sliders with gradient tracks
- `GradientRangeSlider` - Range sliders with gradient tracks

### Text and Icons
- `GradientText` - Text with gradient fill, shadows, and animation effects
- `GradientIcon` - Icons with gradient fill and notification badges

### Navigation
- `GradientAppBar` - App bars with gradient backgrounds
- `GradientTabBar` - Tab bars with gradient backgrounds and custom indicators

### Progress Indicators
- `GradientProgressIndicator` - Linear and circular progress indicators with gradient fills

## Keywords

`flutter`, `gradient`, `ui`, `design`, `colors`, `animation`, `button`, `container`, `text`, `slider`, `progress`, `card`, `appbar`, `tabbar`, `toggle`, `icon`, `divider`, `customization`, `material design`, `themes`, `styling`, `widget`, `effects`, `shadows`, `transformation`

## Requirements

- Flutter SDK: ^3.8.0
- Dart SDK: ^3.8.0

## Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  gradient_color_and_styles: ^1.0.0
```

Run `flutter pub get` to install the package.

## Import

```dart
import 'package:gradient_color_and_styles/gradient_color_and_styles.dart';
```

## Usage

### Using preset gradients

```dart
import 'package:flutter/material.dart';
import 'package:gradient_color_and_styles/gradient_color_and_styles.dart';

// Use a preset gradient with a container
GradientContainer(
  gradient: PresetGradients.sunset,
  height: 100,
  borderRadius: BorderRadius.circular(16),
  child: Center(
    child: Text('Sunset Gradient', style: TextStyle(color: Colors.white)),
  ),
)
```

### Creating custom gradients

```dart
// Create a custom gradient with 3 colors
final customGradient = GradientConfig(
  colors: [
    Colors.purple,
    Colors.blue,
    Colors.cyan,
  ],
  type: GradientType.linear,
  direction: GradientDirection.topLeftToBottomRight,
);

// Generate gradients from a single color
final monochromaticGradient = GradientConfig.monochromatic(
  color: Colors.teal,
  steps: 4,
);

// Create complementary gradients
final complementaryGradient = GradientConfig.complementary(
  baseColor: Colors.orange,
);
```

### Gradient Containers

```dart
// Basic container
GradientContainer(
  gradient: PresetGradients.ocean,
  height: 100,
  width: 200,
  borderRadius: BorderRadius.circular(16),
  elevation: 4.0,
  child: Center(child: Text('Ocean Gradient', style: TextStyle(color: Colors.white))),
)

// Interactive container
GradientContainer(
  gradient: PresetGradients.fire,
  onTap: () => print('Container tapped!'),
  enableInteractiveEffects: true,
  child: Text('Tap me!', style: TextStyle(color: Colors.white)),
)

// Using factory constructors
GradientContainer.card(
  gradient: PresetGradients.nature,
  elevation: 8.0,
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Card Style', style: TextStyle(color: Colors.white)),
  ),
)

GradientContainer.circular(
  gradient: PresetGradients.rainbow,
  size: 100,
  child: Icon(Icons.star, color: Colors.white),
)

// Themed container
GradientContainer.fire(
  child: Text('Fire Theme', style: TextStyle(color: Colors.white)),
  height: 100,
)
```

### Gradient Buttons

```dart
// Basic button
GradientButton(
  gradient: PresetGradients.sunset,
  text: 'Click Me',
  onPressed: () => print('Button pressed!'),
)

// Button with icon
GradientButton(
  gradient: PresetGradients.ocean,
  text: 'Save',
  icon: Icons.save,
  iconPosition: IconPosition.left,
  onPressed: () {},
)

// Loading button
GradientButton(
  gradient: PresetGradients.rainbow,
  text: 'Loading',
  isLoading: true,
  onPressed: () {},
)

// Factory constructors
GradientButton.elevated(
  gradient: PresetGradients.fire,
  text: 'Elevated Button',
  onPressed: () {},
  elevation: 8.0,
)

GradientButton.outlined(
  gradient: PresetGradients.nature,
  text: 'Outlined Button',
  onPressed: () {},
  borderWidth: 2.0,
)
```

### Gradient Text and Icons

```dart
// Basic gradient text
GradientText(
  'Rainbow Text',
  gradient: PresetGradients.rainbow,
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

// Text with shadow
GradientText.withShadow(
  'Text with Shadow',
  gradient: PresetGradients.sunset,
  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  shadowColor: Colors.black54,
  shadowOffset: Offset(2, 2),
)

// Animated text
GradientText.animated(
  'Animated Text',
  gradient: PresetGradients.rainbow,
  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
)

// Gradient icons
GradientIcon(
  icon: Icons.favorite,
  gradient: PresetGradients.sunset,
  size: 48,
)

GradientIcon.withBadge(
  icon: Icons.notifications,
  gradient: PresetGradients.ocean,
  badgeText: '3',
  size: 48,
)
```

### Navigation Components

```dart
// Gradient AppBar
Scaffold(
  appBar: GradientAppBar(
    title: Text('Gradient AppBar'),
    gradient: PresetGradients.ocean,
    elevation: 4.0,
    actions: [
      IconButton(icon: Icon(Icons.settings), onPressed: () {}),
    ],
  ),
  body: // Your content
)

// Gradient TabBar
TabBar(
  controller: _tabController,
  tabs: [
    Tab(text: 'Home'),
    Tab(text: 'Profile'),
    Tab(text: 'Settings'),
  ],
  gradient: PresetGradients.sunset,
)

// Specialized TabBar styles
GradientTabBar.pill(
  gradient: PresetGradients.rainbow,
  controller: _tabController,
  tabs: myTabs,
  indicatorGradient: PresetGradients.ocean,
)
```

### Progress Indicators

```dart
// Linear progress indicator
GradientProgressIndicator.linear(
  gradient: PresetGradients.sunset,
  value: 0.7,
  height: 10.0,
)

// Circular progress indicator
GradientProgressIndicator.circular(
  gradient: PresetGradients.ocean,
  value: 0.35,
  size: 80.0,
  strokeWidth: 8.0,
  showPercentageLabel: true,
)

// Buffer indicator
GradientProgressIndicator.buffer(
  gradient: PresetGradients.rainbow,
  value: 0.3,
  bufferValue: 0.7,
)
```

### Sliders and Controls

```dart
// Gradient slider
GradientSlider(
  gradient: PresetGradients.sunset,
  value: _sliderValue,
  onChanged: (value) {
    setState(() => _sliderValue = value);
  },
)

// Range slider
GradientRangeSlider(
  gradient: PresetGradients.ocean,
  values: _rangeValues,
  onChanged: (values) {
    setState(() => _rangeValues = values);
  },
)

// Toggle switch
GradientToggle(
  value: _toggleValue,
  onChanged: (value) {
    setState(() => _toggleValue = value);
  },
  activeGradient: PresetGradients.sunset,
)
```

### Dividers

```dart
// Horizontal divider
GradientDivider.horizontal(
  gradient: PresetGradients.rainbow,
  thickness: 3.0,
  rounded: true,
)

// Vertical divider
GradientDivider.vertical(
  gradient: PresetGradients.sunset,
  thickness: 2.0,
  height: 100,
)

// Dashed divider
GradientDivider.dashed(
  gradient: PresetGradients.ocean,
  thickness: 2.0,
  dashPattern: [6, 3],
)
```

## Advanced Usage Examples

### Combining Multiple Gradient Widgets

```dart
// Create a gradient card with gradient text and button
GradientCard(
  gradient: PresetGradients.space,
  elevation: 8.0,
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        GradientText.heading(
          'Premium Plan',
          gradient: PresetGradients.sunset,
          fontSize: 24,
        ),
        SizedBox(height: 16),
        Text('Get access to all premium features', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 24),
        GradientButton(
          gradient: PresetGradients.fire,
          text: 'Subscribe Now',
          icon: Icons.star,
          onPressed: () {},
        ),
      ],
    ),
  ),
)
```

### Creating a Custom Theme with Gradients

```dart
// Define your app's gradient theme
class AppGradients {
  static final primary = PresetGradients.ocean;
  static final secondary = PresetGradients.sunset;
  static final accent = PresetGradients.fire;
  static final background = GradientConfig(
    colors: [Colors.grey.shade900, Colors.black],
    direction: GradientDirection.topToBottom,
  );
}

// Use it throughout your app
Scaffold(
  appBar: GradientAppBar(
    title: Text('Themed App'),
    gradient: AppGradients.primary,
  ),
  body: GradientContainer(
    gradient: AppGradients.background,
    child: Center(
      child: GradientButton(
        gradient: AppGradients.accent,
        text: 'Themed Button',
        onPressed: () {},
      ),
    ),
  ),
  floatingActionButton: GradientFAB(
    gradient: AppGradients.secondary,
    icon: Icons.add,
    onPressed: () {},
  ),
)
```

### Creating Dynamic/Animated Gradients

```dart
// Animated container that changes gradient on tap
class AnimatedGradientDemo extends StatefulWidget {
  @override
  State<AnimatedGradientDemo> createState() => _AnimatedGradientDemoState();
}

class _AnimatedGradientDemoState extends State<AnimatedGradientDemo> {
  int _gradientIndex = 0;
  
  final List<GradientConfig> _gradients = [
    PresetGradients.sunset,
    PresetGradients.ocean,
    PresetGradients.fire,
    PresetGradients.nature,
  ];
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gradientIndex = (_gradientIndex + 1) % _gradients.length;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: _gradients[_gradientIndex].toGradient(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text('Tap to change', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
```

### Creating a Custom Gradient Widget

```dart
// Custom widget that applies a gradient overlay on any child
class GradientOverlay extends StatelessWidget {
  final Widget child;
  final GradientConfig gradient;
  final BlendMode blendMode;
  
  const GradientOverlay({
    Key? key,
    required this.child,
    required this.gradient,
    this.blendMode = BlendMode.srcOver,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: blendMode,
      shaderCallback: (bounds) => gradient.toGradient().createShader(bounds),
      child: child,
    );
  }
}

// Usage example
GradientOverlay(
  gradient: PresetGradients.rainbow,
  blendMode: BlendMode.overlay,
  child: Image.asset('assets/photo.jpg'),
)
```

## Preset Gradients

The package comes with several preset gradients that you can use out of the box:

- `PresetGradients.sunset` - Orange to pink sunset-like gradient
- `PresetGradients.ocean` - Blue to cyan ocean-like gradient
- `PresetGradients.fire` - Red to orange fiery gradient
- `PresetGradients.nature` - Green to lime nature-themed gradient
- `PresetGradients.rainbow` - Full spectrum rainbow gradient
- `PresetGradients.sunrise` - Yellow to orange sunrise gradient
- `PresetGradients.space` - Deep purple to blue space-like gradient
- `PresetGradients.darkRadial` - Dark radial gradient for spotlight effects
- `PresetGradients.colorWheel` - Vibrant color wheel gradient

## Gradient Transformations

```dart
// Reverse a gradient's direction
final reversedGradient = myGradient.reversed();

// Rotate a gradient
final rotatedGradient = myGradient.rotated(quarterTurns: 1);

// Tint a gradient with a color
final tintedGradient = myGradient.tinted(Colors.red, strength: 0.3);

// Adjust brightness
final brighterGradient = myGradient.withBrightness(1.3);

// Adjust saturation
final saturatedGradient = myGradient.withSaturation(1.5);
```

## API Reference

### GradientConfig

```dart
GradientConfig({
  required List<Color> colors,
  GradientType type = GradientType.linear,
  GradientDirection direction = GradientDirection.leftToRight,
  List<double>? stops,
  AlignmentGeometry? center,
  double? radius,
  TileMode tileMode = TileMode.clamp,
  double? startAngle,
  double? endAngle,
})
```

Factory Constructors:
- `GradientConfig.monochromatic()` - Creates a gradient from a single color with varying shades
- `GradientConfig.complementary()` - Creates a gradient using complementary colors
- `GradientConfig.triadic()` - Creates a gradient using triadic color harmony
- `GradientConfig.fromColor()` - Creates a gradient that fades from a color to transparent
- `GradientConfig.angle()` - Creates a linear gradient with a specific angle
- `GradientConfig.rainbow()` - Creates a rainbow gradient with customizable steps
- `GradientConfig.mix()` - Creates a gradient by mixing two colors
- `GradientConfig.shade()` - Creates a gradient from dark to light shades of a color

### GradientContainer

```dart
GradientContainer({
  required GradientConfig gradient,
  Widget? child,
  BorderRadius? borderRadius,
  double? width,
  double? height,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  Alignment? alignment,
  BoxBorder? border,
  double elevation = 0.0,
  Color shadowColor = Colors.black54,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  bool enableInteractiveEffects = false,
  double hoverScale = 1.03,
  Duration animationDuration = const Duration(milliseconds: 200),
  Clip clipBehavior = Clip.none,
  BoxShape shape = BoxShape.rectangle,
  Color? backgroundColor,
})
```

### GradientButton

```dart
GradientButton({
  required GradientConfig gradient,
  required String text,
  required VoidCallback onPressed,
  IconData? icon,
  IconPosition iconPosition = IconPosition.left,
  double height = 50.0,
  double? width,
  BorderRadius? borderRadius,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0),
  TextStyle? textStyle,
  Color textColor = Colors.white,
  bool isLoading = false,
  Color loadingColor = Colors.white,
  double loadingSize = 24.0,
  double elevation = 0.0,
  bool animateOnPress = false,
  double pressedScale = 0.95,
})
```

### GradientText

```dart
GradientText(
  String text, {
  required GradientConfig gradient,
  required TextStyle style,
  TextAlign textAlign = TextAlign.center,
  TextDirection? textDirection,
  int? maxLines,
  TextOverflow overflow = TextOverflow.clip,
  bool selectable = false,
  bool softWrap = true,
  double? textScaleFactor,
  List<Shadow>? shadows,
  double? letterSpacing,
  double? wordSpacing,
  double? height,
  String? semanticsLabel,
  bool animateGradient = false,
  Duration animationDuration = const Duration(milliseconds: 3000),
  double? width,
  bool blurEffect = false,
  double blurSigma = 1.0,
  bool gradientShadow = false,
  Offset gradientShadowOffset = const Offset(2.0, 2.0),
})
```

## Performance Considerations

For optimal performance:

1. **Memory Usage**: Avoid creating new `GradientConfig` instances repeatedly in build methods
2. **Animation**: Use `animateGradient` properties sparingly as they can impact performance
3. **Complex UI**: Be cautious when using multiple gradient widgets in scrolling lists

## Troubleshooting

### Common Issues

1. **Gradients not appearing**:
   - Ensure container has non-zero dimensions (width/height)
   - Check that colors list contains at least 2 colors

2. **Animation jank**:
   - Reduce the number of simultaneously animated gradients
   - Increase animation duration for smoother transitions

3. **Text visibility issues**:
   - Ensure text color contrasts well with gradient colors
   - Use `shadow` property to improve readability



## License

This package is licensed under the MIT License - see the LICENSE file for details.

## Contact

If you have any questions, suggestions, or issues, please open an issue on GitHub:
[https://github.com/KANAGARAJ-M/gradient_color_and_styles/issues](https://github.com/KANAGARAJ-M/gradient_color_and_styles/issues)
