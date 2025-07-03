import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/color_picker.dart';
import '../widgets/tag_input.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  
  List<String> _tags = [];
  String _selectedColor = '#FFFFFF';
  bool _isPinned = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _addListeners();
  }

  void _initializeFields() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _categoryController.text = widget.note!.category;
      _tags = List.from(widget.note!.tags);
      _selectedColor = widget.note!.color;
      _isPinned = widget.note!.isPinned;
    } else {
      _categoryController.text = 'General';
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _selectedColor = themeProvider.colorToHex(themeProvider.noteColors.first);
    }
  }

  void _addListeners() {
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
    _categoryController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges && _titleController.text.isEmpty && _contentController.text.isEmpty) {
      return true;
    }

    if (_hasChanges || _titleController.text.isNotEmpty || _contentController.text.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('You have unsaved changes. Do you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    return true;
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title or content'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim().isEmpty 
          ? 'Untitled' 
          : _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _categoryController.text.trim().isEmpty 
          ? 'General' 
          : _categoryController.text.trim(),
      tags: _tags,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
      isPinned: _isPinned,
      color: _selectedColor,
    );

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    try {
      if (widget.note == null) {
        await notesProvider.addNote(note);
      } else {
        await notesProvider.updateNote(note);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.note == null ? 'Note created' : 'Note updated'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    if (widget.note == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      await notesProvider.deleteNote(widget.note!.id!);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.hexToColor(_selectedColor);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                  _hasChanges = true;
                });
              },
            ),
            if (widget.note != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _deleteNote,
              ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveNote,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        hintText: 'Category',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.folder_outlined),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 8),
                    TagInput(
                      tags: _tags,
                      onTagsChanged: (tags) {
                        setState(() {
                          _tags = tags;
                          _hasChanges = true;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Start writing...',
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ColorPicker(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                  _hasChanges = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

