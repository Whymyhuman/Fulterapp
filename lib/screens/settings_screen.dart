import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/notes_provider.dart';
import '../services/preferences_service.dart';
import '../utils/export_import_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  int _appLaunchCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final count = await _preferencesService.getAppLaunchCount();
    setState(() {
      _appLaunchCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Appearance',
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.setDarkMode(value),
                    secondary: Icon(
                      themeProvider.isDarkMode 
                          ? Icons.dark_mode 
                          : Icons.light_mode,
                    ),
                  );
                },
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Grid View'),
                    subtitle: const Text('Show notes in grid layout'),
                    value: themeProvider.isGridView,
                    onChanged: (value) => themeProvider.setGridView(value),
                    secondary: Icon(
                      themeProvider.isGridView 
                          ? Icons.grid_view 
                          : Icons.view_list,
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Data',
            children: [
              ListTile(
                title: const Text('Export Notes'),
                subtitle: const Text('Export all notes to JSON file'),
                leading: const Icon(Icons.file_download),
                onTap: () => _exportNotes(),
              ),
              ListTile(
                title: const Text('Import Notes'),
                subtitle: const Text('Import notes from JSON file'),
                leading: const Icon(Icons.file_upload),
                onTap: () => _importNotes(),
              ),
              const Divider(),
              ListTile(
                title: const Text('Clear All Notes'),
                subtitle: const Text('Delete all notes permanently'),
                leading: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: () => _clearAllNotes(),
              ),
            ],
          ),
          _buildSection(
            title: 'Statistics',
            children: [
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return ListTile(
                    title: const Text('Total Notes'),
                    subtitle: Text('${notesProvider.notesCount} notes'),
                    leading: const Icon(Icons.note),
                  );
                },
              ),
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return ListTile(
                    title: const Text('Pinned Notes'),
                    subtitle: Text('${notesProvider.pinnedNotesCount} pinned'),
                    leading: const Icon(Icons.push_pin),
                  );
                },
              ),
              ListTile(
                title: const Text('App Launches'),
                subtitle: Text('$_appLaunchCount times'),
                leading: const Icon(Icons.launch),
              ),
            ],
          ),
          _buildSection(
            title: 'About',
            children: [
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
                leading: Icon(Icons.info),
              ),
              const ListTile(
                title: Text('Developer'),
                subtitle: Text('Notes App Team'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: const Text('Reset App'),
                subtitle: const Text('Clear all data and preferences'),
                leading: Icon(
                  Icons.restore,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: () => _resetApp(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _exportNotes() async {
    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final success = await ExportImportUtils.exportNotes(notesProvider.allNotes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
                ? 'Notes exported successfully' 
                : 'Failed to export notes'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting notes: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _importNotes() async {
    try {
      final notes = await ExportImportUtils.importNotes();
      if (notes != null && notes.isNotEmpty) {
        final notesProvider = Provider.of<NotesProvider>(context, listen: false);
        
        for (final note in notes) {
          await notesProvider.addNote(note);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Imported ${notes.length} notes'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing notes: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _clearAllNotes() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notes'),
        content: const Text(
          'This will permanently delete all your notes. This action cannot be undone.',
        ),
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
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        final notesProvider = Provider.of<NotesProvider>(context, listen: false);
        // Clear all notes from provider (this will also clear from database)
        for (final note in List.from(notesProvider.allNotes)) {
          await notesProvider.deleteNote(note.id!);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notes deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting notes: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _resetApp() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will delete all notes and reset all preferences. This action cannot be undone.',
        ),
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
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        // Clear all notes
        final notesProvider = Provider.of<NotesProvider>(context, listen: false);
        for (final note in List.from(notesProvider.allNotes)) {
          await notesProvider.deleteNote(note.id!);
        }
        
        // Clear all preferences
        await _preferencesService.clearAll();
        
        // Reset theme provider
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        await themeProvider.initializeTheme();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App reset successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Reload app info
          _loadAppInfo();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error resetting app: $e'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

