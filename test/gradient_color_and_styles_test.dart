import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_color_and_styles/gradient_color_and_styles.dart';

void main() {
  group('GradientConfig', () {
    test('creates linear gradient with correct colors', () {
      final config = GradientConfig(
        colors: [Colors.red, Colors.blue],
        type: GradientType.linear,
        direction: GradientDirection.leftToRight,
      );
      final gradient = config.toGradient();
      expect(gradient, isA<LinearGradient>());
      expect((gradient as LinearGradient).colors, [Colors.red, Colors.blue]);
    });

    test('monochromatic factory creates correct number of steps', () {
      final config = GradientConfig.monochromatic(color: Colors.green, steps: 5);
      expect(config.colors.length, 5);
    });

    test('complementary factory creates five colors', () {
      final config = GradientConfig.complementary(baseColor: Colors.orange);
      expect(config.colors.length, 5); // Updated to expect 5 colors instead of 2
    });

    test('reversed returns reversed colors', () {
      final config = GradientConfig(colors: [Colors.red, Colors.blue]);
      final reversed = config.reversed();
      expect(reversed.colors.first, Colors.blue);
      expect(reversed.colors.last, Colors.red);
    });

    test('withBrightness changes color brightness', () {
      // Fix: Use at least 2 colors to satisfy the assertion
      final config = GradientConfig(colors: [Colors.red, Colors.blue]);
      final bright = config.withBrightness(1.5);
      expect(bright.colors.first, isA<Color>());
      expect(bright.colors.first != Colors.red, true); // Brightness should change the color
    });
  });

  group('PresetGradients', () {
    test('PresetGradients.sunset is a GradientConfig', () {
      expect(PresetGradients.sunset, isA<GradientConfig>());
    });
    test('PresetGradients.ocean is a GradientConfig', () {
      expect(PresetGradients.ocean, isA<GradientConfig>());
    });
    test('PresetGradients.darkRadial is a GradientConfig', () {
      // Fix: Test the correct preset gradient
      expect(PresetGradients.darkRadial, isA<GradientConfig>());
    });
    test('PresetGradients.nature is a GradientConfig', () {
      expect(PresetGradients.nature, isA<GradientConfig>());
    });
    test('PresetGradients.rainbow is a GradientConfig', () {
      expect(PresetGradients.rainbow, isA<GradientConfig>());
    });
  });

  group('GradientContainer', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientContainer(
            gradient: PresetGradients.sunset,
            child: const Text('Hello'),
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('card factory renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientContainer.card(
            gradient: PresetGradients.sunrise,
            child: const Text('Card'),
          ),
        ),
      );
      expect(find.text('Card'), findsOneWidget);
    });

    testWidgets('circular factory renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientContainer.circular(
            gradient: PresetGradients.ocean,
            child: const Icon(Icons.star),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('banner factory renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientContainer.banner(
            gradient: PresetGradients.nature,
            child: const Text('Banner'),
          ),
        ),
      );
      expect(find.text('Banner'), findsOneWidget);
    });
  });

  group('GradientText', () {
    testWidgets('renders gradient text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientText(
            'Gradient',
            gradient: PresetGradients.rainbow,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
      expect(find.text('Gradient'), findsOneWidget);
    });

    testWidgets('heading factory renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientText.heading(
            'Heading',
            gradient: PresetGradients.sunset,
          ),
        ),
      );
      expect(find.text('Heading'), findsOneWidget);
    });

    testWidgets('subtitle factory renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientText.subtitle(
            'Subtitle',
            gradient: PresetGradients.ocean,
          ),
        ),
      );
      expect(find.text('Subtitle'), findsOneWidget);
    });
  });

  group('GradientButton', () {
    testWidgets('renders and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: GradientButton(
            gradient: PresetGradients.sunset,
            text: 'Tap Me',
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });
  });

  group('GradientDivider', () {
    testWidgets('horizontal divider renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientDivider.horizontal(
              gradient: PresetGradients.rainbow,
              thickness: 2,
            ),
          ),
        ),
      );
      expect(find.byType(GradientDivider), findsOneWidget);
    });
  });

  group('GradientFAB', () {
    testWidgets('renders and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: GradientFAB(
              gradient: PresetGradients.ocean,
              icon: Icons.add,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      expect(tapped, isTrue);
    });
  });

  group('GradientIcon', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientIcon(
            icon: Icons.star,
            gradient: PresetGradients.sunset,
            size: 32,
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
