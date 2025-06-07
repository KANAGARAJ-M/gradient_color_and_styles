## 1.0.0

Initial release of the Gradient Colors and Styles package with the following features:

### Core Components
* `GradientConfig` - Flexible gradient configuration with various creation methods
* Preset gradients library with ready-to-use gradient configurations

### Containers and Surfaces
* `GradientContainer` - Customizable container with gradient background
  * Interactive effects (hover/tap animations)
  * Factory constructors: card, circular, banner
  * Theme variants: fire, water, sky, nature, sunset, rainbow, space, darkRadial, sunrise
* `GradientCard` - Card widget with gradient styling
  * Factory constructors: elevated, withHeader

### Dividers
* `GradientDivider` - Customizable divider with gradient coloring
  * Support for horizontal and vertical orientation
  * Factory constructors: horizontal, vertical, dashed
  * Customizable border radius, thickness, and elevation

### Buttons and Controls
* `GradientButton` - Button with gradient background
  * Icon support with customizable position
  * Loading state support
  * Elevation and interactive effects
  * Factory constructors: elevated, outlined, icon
* `GradientFAB` - Floating Action Button with gradient
  * Factory constructors: extended, large, circular
  * Customizable shadows and shapes
* `GradientToggle` - Toggle switch with gradient when active
* `GradientSlider` - Slider with gradient track
  * Factory constructors: discrete, elevated
  * Haptic feedback support
* `GradientRangeSlider` - Range selection with gradient track

### Text and Icons
* `GradientText` - Text with gradient fill
  * Shadow effects and blur support
  * Animation capabilities
  * Factory constructors: heading, subtitle, withShadow, animated, selectable, blurred, gradientShadow
* `GradientIcon` - Icon with gradient fill
  * Interactive (tap/hover) support
  * Badge support for notifications
  * Factory constructors: withBadge, animated, outlined

### Navigation
* `GradientAppBar` - App bar with gradient background
* `GradientTabBar` - Tab bar with gradient background
  * Factory constructors: dots, pill, material3
  * Customizable indicator styles

### Progress Indicators
* `GradientProgressIndicator` - Progress indicators with gradient fill
  * Linear and circular variants
  * Buffer support
  * Factory constructors: linear, linearIndeterminate, circular, circularIndeterminate, buffer
  * Percentage label display

### Utilities
* Gradient transformation methods (reversed, rotated, tinted, brightness/saturation adjustment)
* Multiple gradient types support (linear, radial, sweep)
* Direction control for linear gradients
