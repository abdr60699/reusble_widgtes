
// reusable_tag_input.dart
// Tag / chip input field
import 'package:flutter/material.dart';

typedef TagsChanged = void Function(List<String> tags);

class ReusableTagInput extends StatefulWidget {
  final List<String> initialTags;
  final TagsChanged? onChanged;
  final String hintText;
  final int maxTags;
  final bool allowDuplicates;

  const ReusableTagInput({
    Key? key,
    this.initialTags = const [],
    this.onChanged,
    this.hintText = 'Add tag',
    this.maxTags = 10,
    this.allowDuplicates = false,
  }) : super(key: key);

  @override
  State<ReusableTagInput> createState() => _ReusableTagInputState();
}

class _ReusableTagInputState extends State<ReusableTagInput> {
  late List<String> _tags;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) return;
    if (!widget.allowDuplicates && _tags.contains(tag)) return;
    if (_tags.length >= widget.maxTags) return;
    setState(() {
      _tags.add(tag);
      _controller.clear();
    });
    widget.onChanged?.call(_tags);
  }

  void _removeTagAt(int index) {
    setState(() {
      _tags.removeAt(index);
    });
    widget.onChanged?.call(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ..._tags.asMap().entries.map((e) {
              final idx = e.key;
              final t = e.value;
              return Chip(
                label: Text(t),
                onDeleted: () => _removeTagAt(idx),
              );
            }),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controller,
                onSubmitted: _addTag,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
