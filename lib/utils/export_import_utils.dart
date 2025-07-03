import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class ExportImportUtils {
  static Future<bool> exportNotes(List<Note> notes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/notes_export_$timestamp.json');
      
      final notesJson = notes.map((note) => note.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert({
        'exportDate': DateTime.now().toIso8601String(),
        'notesCount': notes.length,
        'notes': notesJson,
      });
      
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print('Error exporting notes: $e');
      return false;
    }
  }

  static Future<List<Note>?> importNotes() async {
    try {
      // In a real app, you would use file_picker package to let user select file
      // For now, we'll look for the most recent export file
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((file) => file.path.contains('notes_export_') && file.path.endsWith('.json'))
          .cast<File>()
          .toList();
      
      if (files.isEmpty) {
        return null;
      }
      
      // Sort by modification time and get the most recent
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      final file = files.first;
      
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final notesJson = jsonData['notes'] as List<dynamic>;
      final notes = notesJson.map((noteJson) => Note.fromJson(noteJson as Map<String, dynamic>)).toList();
      
      return notes;
    } catch (e) {
      print('Error importing notes: $e');
      return null;
    }
  }

  static Future<List<File>> getExportFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((file) => file.path.contains('notes_export_') && file.path.endsWith('.json'))
          .cast<File>()
          .toList();
      
      // Sort by modification time (newest first)
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      
      return files;
    } catch (e) {
      print('Error getting export files: $e');
      return [];
    }
  }

  static Future<bool> deleteExportFile(File file) async {
    try {
      await file.delete();
      return true;
    } catch (e) {
      print('Error deleting export file: $e');
      return false;
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatExportDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

