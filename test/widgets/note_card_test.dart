import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/widgets/note_card.dart';

void main() {
  group('NoteCard Widget Tests', () {
    late Note testNote;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime.now();
      testNote = Note(
        id: 1,
        title: 'Test Note',
        content: 'This is a test note content',
        category: 'Work',
        tags: ['important', 'urgent'],
        createdAt: testDate,
        updatedAt: testDate,
        isPinned: false,
        color: '#FFFFFF',
      );
    });

    Widget createTestWidget(Note note) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotesProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );
    }

    testWidgets('should display note title and content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      expect(find.text('Test Note'), findsOneWidget);
      expect(find.text('This is a test note content'), findsOneWidget);
    });

    testWidgets('should display category', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      expect(find.text('Work'), findsOneWidget);
    });

    testWidgets('should display tags', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      expect(find.text('#important'), findsOneWidget);
      expect(find.text('#urgent'), findsOneWidget);
    });

    testWidgets('should show pin icon for pinned notes', (WidgetTester tester) async {
      final pinnedNote = testNote.copyWith(isPinned: true);
      await tester.pumpWidget(createTestWidget(pinnedNote));

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('should not show pin icon for unpinned notes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      expect(find.byIcon(Icons.push_pin), findsNothing);
    });

    testWidgets('should show menu button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Note: In a real test, you would verify navigation to edit screen
    });

    testWidgets('should display formatted date', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testNote));

      // The exact text depends on the current time, but we can check that some date text exists
      expect(find.textContaining('Just now'), findsOneWidget);
    });

    testWidgets('should handle empty title', (WidgetTester tester) async {
      final noteWithoutTitle = testNote.copyWith(title: '');
      await tester.pumpWidget(createTestWidget(noteWithoutTitle));

      expect(find.text('Test Note'), findsNothing);
      expect(find.text('This is a test note content'), findsOneWidget);
    });

    testWidgets('should handle empty content', (WidgetTester tester) async {
      final noteWithoutContent = testNote.copyWith(content: '');
      await tester.pumpWidget(createTestWidget(noteWithoutContent));

      expect(find.text('Test Note'), findsOneWidget);
      expect(find.text('This is a test note content'), findsNothing);
    });

    testWidgets('should handle empty category', (WidgetTester tester) async {
      final noteWithoutCategory = testNote.copyWith(category: '');
      await tester.pumpWidget(createTestWidget(noteWithoutCategory));

      expect(find.text('Work'), findsNothing);
    });

    testWidgets('should handle empty tags', (WidgetTester tester) async {
      final noteWithoutTags = testNote.copyWith(tags: []);
      await tester.pumpWidget(createTestWidget(noteWithoutTags));

      expect(find.text('#important'), findsNothing);
      expect(find.text('#urgent'), findsNothing);
    });
  });
}

