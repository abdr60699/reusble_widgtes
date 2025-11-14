import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';
import 'theme_text.dart';
import 'theme_spacing.dart';
import 'theme_radii.dart';
import 'theme_icons.dart';

/// Main application theme configuration
/// Builds complete Material 3 ThemeData for light and dark modes
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== THEME DATA BUILDERS ====================

  /// Build light theme
  static ThemeData get lightTheme {
    final colorScheme = ThemeColors.lightColorScheme;
    final textTheme = ThemeText.buildTextTheme(colorScheme.onBackground);

    return ThemeData(
      // ===== Color Scheme =====
      colorScheme: colorScheme,
      brightness: Brightness.light,
      useMaterial3: true,

      // ===== Scaffold =====
      scaffoldBackgroundColor: colorScheme.background,

      // ===== App Bar =====
      appBarTheme: AppBarTheme(
        elevation: ThemeIcons.appBarElevation,
        centerTitle: false,
        scrolledUnderElevation: ThemeIcons.elevationSm,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: ThemeIcons.appBarIcon,
        ),
        titleTextStyle: ThemeText.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // ===== Card =====
      cardTheme: CardTheme(
        elevation: ThemeIcons.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.cardRadius,
        ),
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        margin: ThemeSpacing.allMd,
      ),

      // ===== Elevated Button =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: ThemeIcons.buttonElevation,
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Filled Button =====
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Outlined Button =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          side: BorderSide(color: colorScheme.outline),
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Text Button =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Floating Action Button =====
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: ThemeIcons.fabElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.radiusLg,
        ),
        iconSize: ThemeIcons.fabIcon,
      ),

      // ===== Input Decoration =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        contentPadding: ThemeSpacing.allMd,
        border: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        errorStyle: ThemeText.bodySmall.copyWith(
          color: colorScheme.error,
        ),
      ),

      // ===== Chip =====
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: ThemeText.labelMedium,
        padding: ThemeSpacing.allXs,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.chipRadius,
        ),
      ),

      // ===== Dialog =====
      dialogTheme: DialogTheme(
        elevation: ThemeIcons.dialogElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.dialogRadius,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: ThemeText.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ===== Bottom Sheet =====
      bottomSheetTheme: BottomSheetThemeData(
        elevation: ThemeIcons.bottomSheetElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.bottomSheetRadius,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),

      // ===== Snackbar =====
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.snackbarRadius,
        ),
        elevation: ThemeIcons.elevationLg,
      ),

      // ===== List Tile =====
      listTileTheme: ListTileThemeData(
        contentPadding: ThemeSpacing.listItemInsets,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.radiusSm,
        ),
        iconColor: colorScheme.onSurfaceVariant,
      ),

      // ===== Divider =====
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: ThemeSpacing.md,
      ),

      // ===== Icon =====
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: ThemeIcons.md,
      ),

      // ===== Typography =====
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // ===== Other =====
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Build dark theme
  static ThemeData get darkTheme {
    final colorScheme = ThemeColors.darkColorScheme;
    final textTheme = ThemeText.buildTextTheme(colorScheme.onBackground);

    return ThemeData(
      // ===== Color Scheme =====
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      useMaterial3: true,

      // ===== Scaffold =====
      scaffoldBackgroundColor: colorScheme.background,

      // ===== App Bar =====
      appBarTheme: AppBarTheme(
        elevation: ThemeIcons.appBarElevation,
        centerTitle: false,
        scrolledUnderElevation: ThemeIcons.elevationSm,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: ThemeIcons.appBarIcon,
        ),
        titleTextStyle: ThemeText.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ===== Card =====
      cardTheme: CardTheme(
        elevation: ThemeIcons.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.cardRadius,
        ),
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        margin: ThemeSpacing.allMd,
      ),

      // ===== Elevated Button =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: ThemeIcons.buttonElevation,
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Filled Button =====
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Outlined Button =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          side: BorderSide(color: colorScheme.outline),
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Text Button =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: ThemeSpacing.buttonInsets,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeRadii.buttonRadius,
          ),
          textStyle: ThemeText.labelLarge,
          minimumSize: const Size(64, 40),
        ),
      ),

      // ===== Floating Action Button =====
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: ThemeIcons.fabElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.radiusLg,
        ),
        iconSize: ThemeIcons.fabIcon,
      ),

      // ===== Input Decoration =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
        contentPadding: ThemeSpacing.allMd,
        border: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: ThemeRadii.inputRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        errorStyle: ThemeText.bodySmall.copyWith(
          color: colorScheme.error,
        ),
      ),

      // ===== Chip =====
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: ThemeText.labelMedium,
        padding: ThemeSpacing.allXs,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.chipRadius,
        ),
      ),

      // ===== Dialog =====
      dialogTheme: DialogTheme(
        elevation: ThemeIcons.dialogElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.dialogRadius,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: ThemeText.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ===== Bottom Sheet =====
      bottomSheetTheme: BottomSheetThemeData(
        elevation: ThemeIcons.bottomSheetElevation,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.bottomSheetRadius,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),

      // ===== Snackbar =====
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: ThemeText.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.snackbarRadius,
        ),
        elevation: ThemeIcons.elevationLg,
      ),

      // ===== List Tile =====
      listTileTheme: ListTileThemeData(
        contentPadding: ThemeSpacing.listItemInsets,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.radiusSm,
        ),
        iconColor: colorScheme.onSurfaceVariant,
      ),

      // ===== Divider =====
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: ThemeSpacing.md,
      ),

      // ===== Icon =====
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: ThemeIcons.md,
      ),

      // ===== Typography =====
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // ===== Other =====
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkRipple.splashFactory,
    );
  }

  // ==================== HELPER METHODS ====================

  /// Get theme based on ThemeMode
  static ThemeData getTheme(ThemeMode mode, Brightness platformBrightness) {
    if (mode == ThemeMode.dark) {
      return darkTheme;
    } else if (mode == ThemeMode.light) {
      return lightTheme;
    } else {
      // System mode
      return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  /// Check if theme is dark
  static bool isDark(ThemeData theme) {
    return theme.brightness == Brightness.dark;
  }
}
