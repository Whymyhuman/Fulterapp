import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/models/note.dart';

void main() {
  group('Note Model Tests', () {
    late DateTime testDate;

    setUp(() {
      testDate = DateTime.now();
    });

    test('should create note with required fields', () {
      final note = Note(
        title: 'Test Note',
        content: 'Test content',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'General');
      expect(note.tags, isEmpty);
      expect(note.isPinned, false);
      expect(note.color, '#FFFFFF');
      expect(note.createdAt, testDate);
      expect(note.updatedAt, testDate);
    });

    test('should create note with all fields', () {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'Test content',
        category: 'Work',
        tags: ['important', 'urgent'],
        createdAt: testDate,
        updatedAt: testDate,
        isPinned: true,
        color: '#FF0000',
      );

      expect(note.id, 1);
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'Work');
      expect(note.tags, ['important', 'urgent']);
      expect(note.isPinned, true);
      expect(note.color, '#FF0000');
    });

    test('should convert note to map correctly', () {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'Test content',
        category: 'Work',
        tags: ['tag1', 'tag2'],
        createdAt: testDate,
        updatedAt: testDate,
        isPinned: true,
        color: '#FF0000',
      );

      final map = note.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test Note');
      expect(map['content'], 'Test content');
      expect(map['category'], 'Work');
      expect(map['tags'], 'tag1,tag2');
      expect(map['createdAt'], testDate.millisecondsSinceEpoch);
      expect(map['updatedAt'], testDate.millisecondsSinceEpoch);
      expect(map['isPinned'], 1);
      expect(map['color'], '#FF0000');
    });

    test('should create note from map correctly', () {
      final map = {
        'id': 1,
        'title': 'Test Note',
        'content': 'Test content',
        'category': 'Work',
        'tags': 'tag1,tag2',
        'createdAt': testDate.millisecondsSinceEpoch,
        'updatedAt': testDate.millisecondsSinceEpoch,
        'isPinned': 1,
        'color': '#FF0000',
      };

      final note = Note.fromMap(map);

      expect(note.id, 1);
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'Work');
      expect(note.tags, ['tag1', 'tag2']);
      expect(note.isPinned, true);
      expect(note.color, '#FF0000');
    });

    test('should handle empty tags in map', () {
      final map = {
        'id': 1,
        'title': 'Test Note',
        'content': 'Test content',
        'category': 'Work',
        'tags': '',
        'createdAt': testDate.millisecondsSinceEpoch,
        'updatedAt': testDate.millisecondsSinceEpoch,
        'isPinned': 0,
        'color': '#FFFFFF',
      };

      final note = Note.fromMap(map);

      expect(note.tags, isEmpty);
      expect(note.isPinned, false);
    });

    test('should copy note with updated fields', () {
      final originalNote = Note(
        id: 1,
        title: 'Original Title',
        content: 'Original content',
        createdAt: testDate,
        updatedAt: testDate,
      );

      final updatedNote = originalNote.copyWith(
        title: 'Updated Title',
        isPinned: true,
      );

      expect(updatedNote.id, 1);
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.content, 'Original content');
      expect(updatedNote.isPinned, true);
      expect(updatedNote.createdAt, testDate);
    });

    test('should convert to JSON correctly', () {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'Test content',
        category: 'Work',
        tags: ['tag1', 'tag2'],
        createdAt: testDate,
        updatedAt: testDate,
        isPinned: true,
        color: '#FF0000',
      );

      final json = note.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Note');
      expect(json['content'], 'Test content');
      expect(json['category'], 'Work');
      expect(json['tags'], ['tag1', 'tag2']);
      expect(json['createdAt'], testDate.toIso8601String());
      expect(json['updatedAt'], testDate.toIso8601String());
      expect(json['isPinned'], true);
      expect(json['color'], '#FF0000');
    });

    test('should create note from JSON correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Note',
        'content': 'Test content',
        'category': 'Work',
        'tags': ['tag1', 'tag2'],
        'createdAt': testDate.toIso8601String(),
        'updatedAt': testDate.toIso8601String(),
        'isPinned': true,
        'color': '#FF0000',
      };

      final note = Note.fromJson(json);

      expect(note.id, 1);
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'Work');
      expect(note.tags, ['tag1', 'tag2']);
      expect(note.isPinned, true);
      expect(note.color, '#FF0000');
    });
  });
}

