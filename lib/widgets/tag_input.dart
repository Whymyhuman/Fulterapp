import 'package:flutter/material.dart';

class TagInput extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;

  const TagInput({
    super.key,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !widget.tags.contains(trimmedTag)) {
      final newTags = List<String>.from(widget.tags)..add(trimmedTag);
      widget.onTagsChanged(newTags);
    }
    _controller.clear();
  }

  void _removeTag(String tag) {
    final newTags = List<String>.from(widget.tags)..remove(tag);
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag input field
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Add tags...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.tag),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addTag(_controller.text),
                  )
                : null,
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: _addTag,
          onChanged: (value) {
            setState(() {}); // Rebuild to show/hide add button
          },
        ),
        
        // Tags display
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.tags.map((tag) {
              return Chip(
                label: Text('#$tag'),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

