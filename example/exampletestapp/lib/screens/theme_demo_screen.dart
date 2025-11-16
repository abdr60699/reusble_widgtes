import 'package:flutter/material.dart';
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_container.dart';

class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({super.key});

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Theme Demo',
        showBackButton: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Material 3 Theme System',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Theme Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.settings),
                      ),
                    ],
                    selected: {_themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      setState(() {
                        _themeMode = newSelection.first;
                      });
                      // Note: In a real app, you would update the MaterialApp's themeMode
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Theme mode changed to ${newSelection.first.name}. This would update the entire app in a real implementation.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Color Palette',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildColorCard('Primary', colorScheme.primary, colorScheme.onPrimary),
          _buildColorCard('Secondary', colorScheme.secondary, colorScheme.onSecondary),
          _buildColorCard('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
          _buildColorCard('Error', colorScheme.error, colorScheme.onError),
          _buildColorCard('Surface', colorScheme.surface, colorScheme.onSurface),
          const SizedBox(height: 24),
          const Text(
            'Typography',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: theme.textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text('Headline Large', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text('Title Large', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Body Large', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Label Large', style: theme.textTheme.labelLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Components',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled Button'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Filled Tonal Button'),
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
                  const SizedBox(height: 16),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: colorScheme.primary,
                      child: Icon(Icons.check, size: 16, color: colorScheme.onPrimary),
                    ),
                    label: const Text('Chip Component'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Custom Widgets with Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ReusableContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 12,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              'This container uses theme colors automatically',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          ReusableContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 12,
            backgroundColor: colorScheme.secondaryContainer,
            child: Text(
              'Secondary container color',
              style: TextStyle(color: colorScheme.onSecondaryContainer),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildColorCard(String name, Color color, Color onColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: onColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              style: TextStyle(
                color: onColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
