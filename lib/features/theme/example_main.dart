/// Complete working example demonstrating the theme system
/// Copy this code to your main.dart to see the theme system in action

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Theme System Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = ref.watch(isDarkThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme System Demo'),
        actions: [
          // Pre-built theme toggle button
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: ThemeSpacing.pageInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== THEME STATUS =====
            _buildSection(
              context,
              title: 'Current Theme',
              child: Container(
                padding: ThemeSpacing.allMd,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: ThemeRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: colors.onPrimaryContainer,
                    ),
                    ThemeSpacing.hGapMd,
                    Text(
                      isDark ? 'Dark Mode Active' : 'Light Mode Active',
                      style: ThemeText.titleMedium.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== THEME MODE SELECTOR =====
            _buildSection(
              context,
              title: 'Theme Mode Selector',
              child: const ThemeModeSelector(),
            ),

            ThemeSpacing.gapXl,

            // ===== COLORS DEMO =====
            _buildSection(
              context,
              title: 'Color Tokens',
              child: Wrap(
                spacing: ThemeSpacing.sm,
                runSpacing: ThemeSpacing.sm,
                children: [
                  _ColorChip(label: 'Primary', color: colors.primary),
                  _ColorChip(label: 'Secondary', color: colors.secondary),
                  _ColorChip(label: 'Tertiary', color: colors.tertiary),
                  _ColorChip(label: 'Success', color: ThemeColors.success),
                  _ColorChip(label: 'Warning', color: ThemeColors.warning),
                  _ColorChip(label: 'Error', color: colors.error),
                ],
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== TYPOGRAPHY DEMO =====
            _buildSection(
              context,
              title: 'Typography Tokens',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: ThemeText.displayLarge),
                  ThemeSpacing.gapXs,
                  Text('Headline Medium', style: ThemeText.headlineMedium),
                  ThemeSpacing.gapXs,
                  Text('Title Large', style: ThemeText.titleLarge),
                  ThemeSpacing.gapXs,
                  Text('Body Large - This is a longer paragraph text demonstrating the body text style with proper line height and letter spacing.', style: ThemeText.bodyLarge),
                  ThemeSpacing.gapXs,
                  Text('Label Medium', style: ThemeText.labelMedium),
                ],
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== SPACING DEMO =====
            _buildSection(
              context,
              title: 'Spacing Tokens',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpacingDemo(label: 'XS (8px)', spacing: ThemeSpacing.xs),
                  ThemeSpacing.gapSm,
                  _SpacingDemo(label: 'SM (12px)', spacing: ThemeSpacing.sm),
                  ThemeSpacing.gapSm,
                  _SpacingDemo(label: 'MD (16px)', spacing: ThemeSpacing.md),
                  ThemeSpacing.gapSm,
                  _SpacingDemo(label: 'LG (24px)', spacing: ThemeSpacing.lg),
                  ThemeSpacing.gapSm,
                  _SpacingDemo(label: 'XL (32px)', spacing: ThemeSpacing.xl),
                ],
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== BORDER RADIUS DEMO =====
            _buildSection(
              context,
              title: 'Border Radius Tokens',
              child: Wrap(
                spacing: ThemeSpacing.md,
                runSpacing: ThemeSpacing.md,
                children: [
                  _RadiusDemo(label: 'XS', radius: ThemeRadii.radiusXs),
                  _RadiusDemo(label: 'SM', radius: ThemeRadii.radiusSm),
                  _RadiusDemo(label: 'MD', radius: ThemeRadii.radiusMd),
                  _RadiusDemo(label: 'LG', radius: ThemeRadii.radiusLg),
                  _RadiusDemo(label: 'XL', radius: ThemeRadii.radiusXl),
                  _RadiusDemo(label: 'Full', radius: ThemeRadii.radiusFull),
                ],
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== BUTTONS DEMO =====
            _buildSection(
              context,
              title: 'Buttons',
              child: Wrap(
                spacing: ThemeSpacing.sm,
                runSpacing: ThemeSpacing.sm,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text'),
                  ),
                ],
              ),
            ),

            ThemeSpacing.gapXl,

            // ===== CARDS DEMO =====
            _buildSection(
              context,
              title: 'Cards',
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: ThemeSpacing.cardInsets,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card Title', style: ThemeText.titleLarge),
                          ThemeSpacing.gapSm,
                          Text(
                            'This is a card with themed padding, border radius, and elevation.',
                            style: ThemeText.bodyMedium,
                          ),
                          ThemeSpacing.gapMd,
                          FilledButton.tonal(
                            onPressed: () {},
                            child: const Text('Action'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ThemeSpacing.gapXxl,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle theme
          ref.read(themeControllerProvider).toggleTheme();
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ThemeText.headlineSmall,
        ),
        ThemeSpacing.gapMd,
        child,
      ],
    );
  }
}

// ===== HELPER WIDGETS =====

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = ThemeColors.isLightColor(color);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: ThemeRadii.radiusSm,
      ),
      child: Text(
        label,
        style: ThemeText.labelMedium.copyWith(
          color: isLight ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

class _SpacingDemo extends StatelessWidget {
  final String label;
  final double spacing;

  const _SpacingDemo({
    required this.label,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: ThemeText.bodySmall),
        ),
        Container(
          width: spacing,
          height: 24,
          color: colors.primary,
        ),
      ],
    );
  }
}

class _RadiusDemo extends StatelessWidget {
  final String label;
  final BorderRadius radius;

  const _RadiusDemo({
    required this.label,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: radius,
          ),
        ),
        ThemeSpacing.gapXs,
        Text(label, style: ThemeText.labelSmall),
      ],
    );
  }
}
