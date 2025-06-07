import 'package:flutter/material.dart';
import 'package:gradient_color_and_styles/gradient_color_and_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Colors and Styles Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gradient Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  // Tab controller for the section tabs
  late TabController _tabController;
  
  // Create a custom gradient
  final customGradient = GradientConfig(
    colors: [
      Colors.purple,
      Colors.blue,
      Colors.cyan,
    ],
    type: GradientType.linear,
    direction: GradientDirection.topLeftToBottomRight,
  );
  
  // Custom monochromatic gradient
  final monochromaticGradient = GradientConfig.monochromatic(
    color: Colors.teal,
    steps: 4,
  );
  
  // Custom complementary gradient
  final complementaryGradient = GradientConfig.complementary(
    baseColor: Colors.orange,
  );
  
  // Slider value for demo
  double _sliderValue = 0.4;
  RangeValues _rangeValues = const RangeValues(0.2, 0.8);
  
  // Toggle value for demo
  bool _toggleValue = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Gradient Styles Demo'),
        gradient: PresetGradients.ocean,
        elevation: 4.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
        bottom: GradientTabBar(
          gradient: PresetGradients.ocean.withBrightness(0.8),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Containers'),
            Tab(text: 'Buttons'),
            Tab(text: 'Text'),
            Tab(text: 'Controls'),
            Tab(text: 'Effects'),
          ],
          showDivider: false,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10),
          tabAlignment: TabAlignment.center,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContainersTab(),
          _buildButtonsTab(),
          _buildTextTab(),
          _buildControlsTab(),
          _buildEffectsTab(),
        ],
      ),
      floatingActionButton: GradientFAB(
        gradient: PresetGradients.rainbow,
        icon: Icons.add,
        onPressed: () {},
        elevation: 8.0,
        shadowColor: Colors.black45,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: PresetGradients.ocean.withBrightness(0.8).toGradient(),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationItem(icon: Icons.home, label: 'Home'),
            BottomNavigationItem(icon: Icons.favorite, label: 'Favorites'),
            BottomNavigationItem(icon: Icons.settings, label: 'Settings'),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
    );
  }
  
  // Containers Tab
  Widget _buildContainersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic Containers Section
          _buildSectionHeader('Basic Containers'),
          
          Row(
            children: [
              Expanded(
                child: GradientContainer(
                  gradient: PresetGradients.sunset,
                  height: 100,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 4.0,
                  child: const Center(
                    child: Text('Sunset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientContainer(
                  gradient: PresetGradients.nature,
                  height: 100,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 4.0,
                  child: const Center(
                    child: Text('Nature', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Interactive Container
          GradientContainer(
            gradient: customGradient,
            height: 100,
            borderRadius: BorderRadius.circular(16),
            enableInteractiveEffects: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Container tapped!')),
            ),
            elevation: 4.0,
            child: const Center(
              child: Text('Interactive Container (Tap Me)', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          
          // Factory Constructors Demo
          _buildSectionHeader('Container Variations'),
          
          Row(
            children: [
              Expanded(
                child: GradientContainer.card(
                  gradient: PresetGradients.sunrise,
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  onTap: () {},
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.credit_card, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text('Card Style', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    GradientContainer.circular(
                      gradient: PresetGradients.space,
                      size: 80,
                      elevation: 4.0,
                      child: const Icon(Icons.star, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 8),
                    const Text('Circular'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          GradientContainer.banner(
            gradient: complementaryGradient,
            height: 80,
            child: const Center(
              child: Text('Banner Container', 
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Cards Section
          _buildSectionHeader('Gradient Cards'),
          
          Row(
            children: [
              Expanded(
                child: GradientCard(
                  gradient: PresetGradients.ocean,
                  height: 120,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 4.0,
                  onTap: () {},
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.water, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text('Interactive Card', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientCard.elevated(
                  gradient: PresetGradients.sunset,
                  elevation: 8.0,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sunny, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text('Elevated Card', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          GradientCard.withHeader(
            headerGradient: PresetGradients.nature,
            bodyGradient: GradientConfig(
              colors: [Colors.white, Colors.grey.shade100],
              direction: GradientDirection.topToBottom,
            ),
            headerContent: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.forest, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Card with Header', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            bodyContent: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('This card has a separate header and body section with different gradients.'),
            ),
            elevation: 4.0,
          ),
          
          const SizedBox(height: 16),
          
          // Dividers Section
          _buildSectionHeader('Gradient Dividers'),
          
          GradientDivider.horizontal(
            gradient: PresetGradients.rainbow,
            thickness: 3.0,
            rounded: true,
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientDivider.vertical(
                gradient: PresetGradients.sunset,
                
                thickness: 2.0,
                elevation: 2.0,
              ),
              GradientDivider.dashed(
                gradient: PresetGradients.ocean,
                thickness: 2.0,
                dashPattern: const [6, 3],
              ),
              GradientDivider.vertical(
                gradient: PresetGradients.nature,
                thickness: 2.0,
                elevation: 2.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Buttons Tab
  Widget _buildButtonsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic Buttons
          _buildSectionHeader('Basic Buttons'),
          
          GradientButton(
            gradient: PresetGradients.ocean,
            text: 'Standard Button',
            onPressed: () {},
            height: 50,
            borderRadius: BorderRadius.circular(25),
            elevation: 3.0,
          ),
          const SizedBox(height: 16),
          
          GradientButton(
            gradient: PresetGradients.sunrise,
            text: 'Button with Icon',
            icon: Icons.sunny,
            iconPosition: IconPosition.left,
            onPressed: () {},
            height: 50,
            elevation: 3.0,
          ),
          const SizedBox(height: 16),
          
          // Factory constructors
          _buildSectionHeader('Button Variations'),
          
          Row(
            children: [
              Expanded(
                child: GradientButton.elevated(
                  gradient: PresetGradients.ocean,
                  text: 'Elevated',
                  onPressed: () {},
                  elevation: 8.0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientButton.outlined(
                  gradient: PresetGradients.space,
                  text: 'Outlined',
                  onPressed: () {},
                  borderWidth: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          GradientButton.icon(
            gradient: complementaryGradient,
            text: 'Icon Button',
            icon: Icons.star,
            onPressed: () {},
            iconPosition: IconPosition.right,
          ),
          const SizedBox(height: 16),
          
          // Loading button
          GradientButton(
            gradient: PresetGradients.rainbow,
            text: 'Loading Button',
            onPressed: () {},
            isLoading: true,
            loadingColor: Colors.white,
          ),
          const SizedBox(height: 16),
          
          // Animated button with scale effect
          GradientButton(
            gradient: monochromaticGradient,
            text: 'Animated Button (Press Me)',
            onPressed: () {},
            animateOnPress: true,
            pressedScale: 0.95,
            elevation: 4.0,
          ),
          const SizedBox(height: 24),
          
          // Floating Action Buttons
          _buildSectionHeader('Floating Action Buttons'),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientFAB.circular(
                gradient: PresetGradients.sunset,
                icon: Icons.add,
                onPressed: () {},
                size: 56,
              ),
              GradientFAB.large(
                gradient: PresetGradients.ocean,
                icon: Icons.favorite,
                onPressed: () {},
                iconSize: 32,
              ),
              GradientFAB.extended(
                gradient: PresetGradients.nature,
                icon: Icons.eco,
                label: 'Extended',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Text Tab
  Widget _buildTextTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic Gradient Text
          _buildSectionHeader('Basic Gradient Text'),
          
          GradientText(
            'Rainbow Gradient Text',
            gradient: PresetGradients.rainbow,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          GradientText(
            'Custom Gradient Text',
            gradient: customGradient,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Factory Constructors
          _buildSectionHeader('Text Variations'),
          
          GradientText.heading(
            'Heading Style Text',
            gradient: PresetGradients.nature,
            fontSize: 30,
          ),
          const SizedBox(height: 8),
          
          GradientText.subtitle(
            'This is a subtitle with gradient',
            gradient: PresetGradients.ocean,
            fontSize: 18,
          ),
          const SizedBox(height: 16),
          
          GradientText.withShadow(
            'Text with Shadow Effect',
            gradient: PresetGradients.sunset,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            shadowColor: Colors.black54,
            shadowOffset: const Offset(2, 2),
            shadowBlur: 4.0,
          ),
          const SizedBox(height: 16),
          
          GradientText.animated(
            'Animated Gradient Text',
            gradient: PresetGradients.rainbow,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            animationDuration: const Duration(seconds: 3),
          ),
          const SizedBox(height: 16),
          
          GradientText.blurred(
            'Blurred Gradient Text',
            gradient: PresetGradients.space,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            blurSigma: 1.5,
          ),
          const SizedBox(height: 16),
          
          GradientText.gradientShadow(
            'Gradient Shadow Effect',
            gradient: PresetGradients.nature,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            shadowOffset: const Offset(3, 3),
          ),
          const SizedBox(height: 24),
          
          // Gradient Icons
          _buildSectionHeader('Gradient Icons'),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientIcon(
                icon: Icons.favorite,
                gradient: PresetGradients.sunset,
                size: 48,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Heart icon tapped!')),
                ),
              ),
              GradientIcon.withBadge(
                icon: Icons.notifications,
                gradient: PresetGradients.ocean,
                badgeText: '3',
                size: 48,
                onTap: () {},
              ),
              GradientIcon.animated(
                icon: Icons.star,
                gradient: PresetGradients.rainbow,
                size: 48,
              ),
              GradientIcon.outlined(
                icon: Icons.eco,
                gradient: PresetGradients.nature,
                size: 48,
                outlineThickness: 2.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Controls Tab (Sliders, Toggle, etc.)
  Widget _buildControlsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sliders Section
          _buildSectionHeader('Gradient Sliders'),
          
          GradientSlider(
            gradient: PresetGradients.sunset,
            value: _sliderValue,
            onChanged: (value) {
              setState(() => _sliderValue = value);
            },
            
          ),
          const SizedBox(height: 16),
          
          // Range Slider
          _buildSectionHeader('Range Slider'),
          
          // Using standard RangeSlider with decoration since GradientRangeSlider isn't available
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: RangeSlider(
              values: _rangeValues,
              onChanged: (values) {
                setState(() => _rangeValues = values);
              },
              min: 0.0,
              max: 1.0,
              divisions: 10,
              labels: RangeLabels(
                '${(_rangeValues.start * 100).toInt()}',
                '${(_rangeValues.end * 100).toInt()}'
              ),
              activeColor: PresetGradients.space.colors[0],
            ),
          ),
          const SizedBox(height: 24),
          
          // Toggle Button
          _buildSectionHeader('Toggle Button'),
          
          Center(
            child: GradientToggle(
              value: _toggleValue,
              onChanged: (value) {
                setState(() => _toggleValue = value);
              },
              activeGradient: PresetGradients.ocean,
              width: 60,
              height: 30,
            ),
          ),
          const SizedBox(height: 24),
          
          // Progress Indicators
          _buildSectionHeader('Progress Indicators'),
          
          GradientProgressIndicator.linear(
            gradient: PresetGradients.sunset,
            value: 0.7,
            height: 10.0,
            animate: true,
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GradientProgressIndicator.circular(
                    gradient: PresetGradients.ocean,
                    value: 0.35,
                    size: 80.0,
                    strokeWidth: 8.0,
                    showPercentageLabel: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Determinate'),
                ],
              ),
              Column(
                children: [
                  GradientProgressIndicator.circularIndeterminate(
                    gradient: PresetGradients.rainbow,
                    size: 80.0,
                    strokeWidth: 8.0,
                  ),
                  const SizedBox(height: 8),
                  const Text('Indeterminate'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          GradientProgressIndicator.buffer(
            gradient: complementaryGradient,
            value: 0.3,
            bufferValue: 0.7,
            height: 8.0,
          ),
        ],
      ),
    );
  }
  
  // Effects and Extras Tab
  Widget _buildEffectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gradient Config Demonstrations
          _buildSectionHeader('Gradient Transformations'),
          
          _buildGradientSample('Original', customGradient),
          _buildGradientSample('Reversed', customGradient.reversed()),
          _buildGradientSample('Rotated (90°)', customGradient.rotated(quarterTurns: 1)),
          _buildGradientSample('Tinted (Red)', customGradient.tinted(Colors.red, strength: 0.3)),
          _buildGradientSample('Brightness Adjusted', customGradient.withBrightness(1.3)),
          _buildGradientSample('Saturation Adjusted', customGradient.withSaturation(1.5)),
          
          const SizedBox(height: 24),
          
          // Gradient Generation Methods
          _buildSectionHeader('Gradient Generation'),
          
          Row(
            children: [
              Expanded(child: _buildGradientSample('Monochromatic', 
                GradientConfig.monochromatic(color: Colors.blue))),
              const SizedBox(width: 8),
              Expanded(child: _buildGradientSample('Complementary', 
                GradientConfig.complementary(baseColor: Colors.blue))),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(child: _buildGradientSample('Mix', 
                GradientConfig.mix(color1: Colors.blue, color2: Colors.green))),
              const SizedBox(width: 8),
              Expanded(child: _buildGradientSample('Triadic', 
                GradientConfig.triadic(baseColor: Colors.blue))),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(child: _buildGradientSample('Single Color Fade', 
                GradientConfig.fromColor(color: Colors.blue))),
              const SizedBox(width: 8),
              Expanded(child: _buildGradientSample('Angle (45°)', 
                GradientConfig.angle(colors: [Colors.red, Colors.yellow], angle: 45))),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(child: _buildGradientSample('Shade (Dark to Light)', 
                GradientConfig.shade(color: Colors.blue))),
              const SizedBox(width: 8),
              Expanded(child: _buildGradientSample('Rainbow', 
                GradientConfig.rainbow(steps: 7))),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Preset Gradients Section
          _buildSectionHeader('Preset Gradients'),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetGradientChip(PresetGradients.sunset, 'Sunset'),
              _buildPresetGradientChip(PresetGradients.ocean, 'Ocean'),
              _buildPresetGradientChip(PresetGradients.nature, 'Nature'),
              _buildPresetGradientChip(PresetGradients.rainbow, 'Rainbow'),
              _buildPresetGradientChip(PresetGradients.sunrise, 'Sunrise'),
              _buildPresetGradientChip(PresetGradients.space, 'Space'),
              _buildPresetGradientChip(PresetGradients.darkRadial, 'Dark Radial'),
              _buildPresetGradientChip(PresetGradients.colorWheel, 'Color Wheel'),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper widgets
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGradientSample(String label, GradientConfig gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient.toGradient(),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
  
  Widget _buildPresetGradientChip(GradientConfig gradient, String name) {
    return GradientContainer(
      gradient: gradient,
      height: 40,
      width: 100,
      borderRadius: BorderRadius.circular(20),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Simple Bottom Navigation Item class
class BottomNavigationItem extends BottomNavigationBarItem {
  BottomNavigationItem({
    required IconData icon,
    required String label,
  }) : super(
    icon: Icon(icon),
    label: label,
  );
}
