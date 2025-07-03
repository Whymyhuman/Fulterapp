import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _selectedTags = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Note> get notes => _filteredNotes;
  List<Note> get allNotes => _notes;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get selectedTags => _selectedTags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all notes
  Future<void> loadNotes() async {
    _setLoading(true);
    try {
      _notes = await _databaseService.getAllNotes();
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading notes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new note
  Future<void> addNote(Note note) async {
    try {
      final id = await _databaseService.insertNote(note);
      final newNote = note.copyWith(id: id);
      _notes.insert(0, newNote);
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding note: $e');
    }
  }

  // Update existing note
  Future<void> updateNote(Note note) async {
    try {
      await _databaseService.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        _applyFilters();
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating note: $e');
    }
  }

  // Delete note
  Future<void> deleteNote(int id) async {
    try {
      await _databaseService.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting note: $e');
    }
  }

  // Search notes
  void searchNotes(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Filter by tags
  void filterByTags(List<String> tags) {
    _selectedTags = tags;
    _applyFilters();
  }

  // Toggle pin status
  Future<void> togglePin(Note note) async {
    final updatedNote = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await updateNote(updatedNote);
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final categories = await _databaseService.getAllCategories();
      return ['All', ...categories];
    } catch (e) {
      debugPrint('Error getting categories: $e');
      return ['All'];
    }
  }

  // Get all tags
  Future<List<String>> getTags() async {
    try {
      return await _databaseService.getAllTags();
    } catch (e) {
      debugPrint('Error getting tags: $e');
      return [];
    }
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedTags = [];
    _applyFilters();
  }

  // Apply filters to notes
  void _applyFilters() {
    _filteredNotes = _notes.where((note) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      // Category filter
      bool matchesCategory = _selectedCategory == 'All' || note.category == _selectedCategory;

      // Tags filter
      bool matchesTags = _selectedTags.isEmpty ||
          _selectedTags.every((tag) => note.tags.contains(tag));

      return matchesSearch && matchesCategory && matchesTags;
    }).toList();

    // Sort: pinned notes first, then by updated date
    _filteredNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get note by id
  Note? getNoteById(int id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get notes count
  int get notesCount => _notes.length;
  int get filteredNotesCount => _filteredNotes.length;

  // Get pinned notes count
  int get pinnedNotesCount => _notes.where((note) => note.isPinned).length;
}

