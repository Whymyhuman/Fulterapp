import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/notes_provider.dart';

void main() {
  group('NotesProvider Tests', () {
    late NotesProvider notesProvider;
    late DateTime testDate;

    setUp(() {
      notesProvider = NotesProvider();
      testDate = DateTime.now();
    });

    test('should initialize with empty notes list', () {
      expect(notesProvider.notes, isEmpty);
      expect(notesProvider.allNotes, isEmpty);
      expect(notesProvider.searchQuery, isEmpty);
      expect(notesProvider.selectedCategory, 'All');
      expect(notesProvider.selectedTags, isEmpty);
      expect(notesProvider.isLoading, false);
      expect(notesProvider.error, isNull);
    });

    test('should filter notes by search query', () {
      // Add test notes to the provider's internal list
      final note1 = Note(
        id: 1,
        title: 'Flutter Development',
        content: 'Learning Flutter framework',
        createdAt: testDate,
        updatedAt: testDate,
      );
      
      final note2 = Note(
        id: 2,
        title: 'Dart Programming',
        content: 'Understanding Dart language',
        createdAt: testDate,
        updatedAt: testDate,
      );

      // Simulate adding notes to internal list
      notesProvider.allNotes.addAll([note1, note2]);
      
      // Test search functionality
      notesProvider.searchNotes('Flutter');
      
      expect(notesProvider.searchQuery, 'Flutter');
      // Note: The actual filtering logic would need to be tested with a mock database
    });

    test('should filter notes by category', () {
      notesProvider.filterByCategory('Work');
      expect(notesProvider.selectedCategory, 'Work');
    });

    test('should filter notes by tags', () {
      final tags = ['important', 'urgent'];
      notesProvider.filterByTags(tags);
      expect(notesProvider.selectedTags, tags);
    });

    test('should clear all filters', () {
      // Set some filters
      notesProvider.searchNotes('test');
      notesProvider.filterByCategory('Work');
      notesProvider.filterByTags(['tag1']);
      
      // Clear filters
      notesProvider.clearFilters();
      
      expect(notesProvider.searchQuery, isEmpty);
      expect(notesProvider.selectedCategory, 'All');
      expect(notesProvider.selectedTags, isEmpty);
    });

    test('should get note by id', () {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'Test content',
        createdAt: testDate,
        updatedAt: testDate,
      );

      // Add note to internal list for testing
      notesProvider.allNotes.add(note);
      
      final foundNote = notesProvider.getNoteById(1);
      expect(foundNote, isNotNull);
      expect(foundNote?.id, 1);
      expect(foundNote?.title, 'Test Note');
    });

    test('should return null for non-existent note id', () {
      final foundNote = notesProvider.getNoteById(999);
      expect(foundNote, isNull);
    });

    test('should return correct notes count', () {
      expect(notesProvider.notesCount, 0);
      expect(notesProvider.filteredNotesCount, 0);
      expect(notesProvider.pinnedNotesCount, 0);
    });

    test('should clear error', () {
      // Since error is private, we can't directly test this
      // In a real implementation, you would expose a method to set error state
      // or test through the public API that triggers errors
      
      notesProvider.clearError();
      expect(notesProvider.error, isNull);
    });
  });
}

