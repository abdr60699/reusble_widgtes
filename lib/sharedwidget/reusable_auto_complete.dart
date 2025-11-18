// reusable_auto_complete.dart
// Wrapper around Flutter's Autocomplete with simple configuration
import 'package:flutter/material.dart';

typedef SuggestionCallback<T extends Object> = Future<List<T>> Function(String query);

class ReusableAutoComplete<T extends Object> extends StatefulWidget {
  final List<T>? options; // optional local options
  final SuggestionCallback<T>? suggestionsCallback; // async suggestions
  final String Function(T) displayStringForOption;
  final ValueChanged<T>? onSelected;
  final InputDecoration? decoration;

  const ReusableAutoComplete({
    Key? key,
    this.options,
    this.suggestionsCallback,
    required this.displayStringForOption,
    this.onSelected,
    this.decoration,
  })  : assert(options != null || suggestionsCallback != null,
            'Either options or suggestionsCallback must be provided'),
        super(key: key);

  @override
  State<ReusableAutoComplete<T>> createState() => _ReusableAutoCompleteState<T>();
}

class _ReusableAutoCompleteState<T extends Object> extends State<ReusableAutoComplete<T>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<T>> _getSuggestions(String query) async {
    if (widget.suggestionsCallback != null) {
      return await widget.suggestionsCallback!(query);
    }
    final q = query.toLowerCase();
    return widget.options!
        .where((o) => widget.displayStringForOption(o).toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text == '') return [];
        final list = await _getSuggestions(textEditingValue.text);
        return list;
      },
      displayStringForOption: widget.displayStringForOption,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        controller.text = _controller.text;
        controller.selection = _controller.selection;
        controller.addListener(() {
          _controller.text = controller.text;
          _controller.selection = controller.selection;
        });
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: widget.decoration ?? const InputDecoration(),
        );
      },
      onSelected: widget.onSelected,
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: options.map((opt) {
              return ListTile(
                title: Text(widget.displayStringForOption(opt)),
                onTap: () => onSelected(opt),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}