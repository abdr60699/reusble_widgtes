// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'basic_theme.dart';

/// Example app demonstrating the Basic Theme System
///
/// This example shows:
/// - How to set up the theme
/// - How to switch between light/dark/system modes
/// - How to use theme colors and typography
/// - Pre-built theme widgets
///
/// To run this example:
/// 1. Replace your main.dart with this file, OR
/// 2. Run: flutter run -t lib/features/basic_theme/example_basic_theme.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize the theme manager
  final themeManager = BasicThemeManager();
  await themeManager.initialize();

  runApp(BasicThemeExampleApp(themeManager: themeManager));
}

class BasicThemeExampleApp extends StatefulWidget {
  final BasicThemeManager themeManager;

  const BasicThemeExampleApp({super.key, required this.themeManager});

  @override
  _BasicThemeExampleAppState createState() => _BasicThemeExampleAppState();
}

class _BasicThemeExampleAppState extends State<BasicThemeExampleApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes and rebuild
    widget.themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Theme Example',
      debugShowCheckedModeBanner: false,
      // Apply light theme
      theme: BasicThemeConfig.lightTheme,
      // Apply dark theme
      darkTheme: BasicThemeConfig.darkTheme,
      // Use theme mode from manager (supports system mode)
      themeMode: widget.themeManager.themeMode,
      home: ExampleHomePage(themeManager: widget.themeManager),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  final BasicThemeManager themeManager;

  const ExampleHomePage({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Theme Example'),
        actions: [
          // Pre-built theme toggle button
          BasicThemeToggleButton(themeManager: themeManager),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Section
          Text(
            'Welcome to Basic Theme!',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'A simple theme system with light, dark, and system modes.',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Theme Mode Selector Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette, color: colors.primary),
                      const SizedBox(width: 8),
                      Text('Theme Settings', style: textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pre-built theme mode selector
                  BasicThemeModeSelector(themeManager: themeManager),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Color Palette Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Color Palette', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _ColorSwatch(
                    label: 'Primary',
                    color: colors.primary,
                    onColor: colors.onPrimary,
                  ),
                  const SizedBox(height: 8),
                  _ColorSwatch(
                    label: 'Secondary',
                    color: colors.secondary,
                    onColor: colors.onSecondary,
                  ),
                  const SizedBox(height: 8),
                  _ColorSwatch(
                    label: 'Error',
                    color: colors.error,
                    onColor: colors.onError,
                  ),
                  const SizedBox(height: 8),
                  _ColorSwatch(
                    label: 'Surface',
                    color: colors.surface,
                    onColor: colors.onSurface,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Typography Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Typography', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text('Headline Large', style: textTheme.headlineLarge),
                  Text('Headline Medium', style: textTheme.headlineMedium),
                  Text('Headline Small', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Title Large', style: textTheme.titleLarge),
                  Text('Title Medium', style: textTheme.titleMedium),
                  Text('Title Small', style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text('Body Large', style: textTheme.bodyLarge),
                  Text('Body Medium', style: textTheme.bodyMedium),
                  Text('Body Small', style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Buttons Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Buttons', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Button with Icon'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Form Elements Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Form Elements', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Text Field',
                      hintText: 'Enter text here',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 8),
                      const Text('Checkbox'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 8),
                      const Text('Radio Button'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 8),
                      const Text('Switch'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Info Card
          Card(
            color: colors.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colors.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Using Theme Colors',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This card uses primaryContainer and onPrimaryContainer colors, which automatically adapt to the current theme.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Manual Theme Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Manual Controls', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => themeManager.setLightMode(),
                    child: const Text('Set Light Mode'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => themeManager.setDarkMode(),
                    child: const Text('Set Dark Mode'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => themeManager.setSystemMode(),
                    child: const Text('Set System Mode'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => themeManager.toggleTheme(),
                    child: const Text('Toggle Light/Dark'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Current Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Status', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Theme Mode: ${themeManager.themeModeDisplayName}',
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    'Brightness: ${Theme.of(context).brightness.name}',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Current theme: ${themeManager.themeModeDisplayName}',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Icon(themeManager.themeModeIcon),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final Color onColor;

  const _ColorSwatch({
    required this.label,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: onColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
            style: TextStyle(
              color: onColor,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
