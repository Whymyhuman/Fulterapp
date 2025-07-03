import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback onClose;

  const SearchBarWidget({super.key, required this.onClose});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    
    // Set initial value if there's an existing search
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    _controller.text = notesProvider.searchQuery;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'Search notes...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (query) {
              Provider.of<NotesProvider>(context, listen: false)
                  .searchNotes(query);
            },
            onSubmitted: (query) {
              if (query.trim().isEmpty) {
                widget.onClose();
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              _controller.clear();
              Provider.of<NotesProvider>(context, listen: false)
                  .searchNotes('');
            } else {
              widget.onClose();
            }
          },
        ),
      ],
    );
  }
}

