import 'package:flutter/material.dart';

/// A reusable autocomplete widget with search and suggestions.
///
/// This widget provides type-ahead functionality with customizable options.
/// Supports both String and custom objects with a display builder.
///
/// Example:
/// ```dart
/// ReusableAutoComplete<String>(
///   options: ['Apple', 'Banana', 'Cherry'],
///   onSelected: (value) => print('Selected: $value'),
///   labelText: 'Search fruits',
/// )
/// ```
class ReusableAutoComplete<T extends Object> extends StatelessWidget {
  /// List of options to display in suggestions
  final List<T> options;

  /// Callback when an option is selected
  final Function(T) onSelected;

  /// How to display each option (for custom objects)
  final String Function(T)? displayStringForOption;

  /// Label text for the field
  final String? labelText;

  /// Hint text
  final String? hintText;

  /// Prefix icon
  final IconData? prefixIcon;

  const ReusableAutoComplete({
    super.key,
    required this.options,
    required this.onSelected,
    this.displayStringForOption,
    this.labelText,
    this.hintText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<T>.empty();
        }
        return options.where((T option) {
          final String displayString = displayStringForOption != null
              ? displayStringForOption!(option)
              : option.toString();
          return displayString
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: displayStringForOption ?? (T option) => option.toString(),
      onSelected: onSelected,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: const OutlineInputBorder(),
          ),
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
    );
  }
}
