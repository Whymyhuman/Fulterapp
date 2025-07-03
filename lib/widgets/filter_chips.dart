import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({super.key});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  List<String> _categories = ['All'];
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final categories = await notesProvider.getCategories();
    final tags = await notesProvider.getTags();
    
    setState(() {
      _categories = categories;
      _tags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        final hasFilters = notesProvider.selectedCategory != 'All' ||
            notesProvider.selectedTags.isNotEmpty;

        if (_categories.length <= 1 && _tags.isEmpty && !hasFilters) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Category filters
              if (_categories.length > 1) ...[
                ..._categories.map((category) {
                  final isSelected = notesProvider.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        notesProvider.filterByCategory(category);
                      },
                      avatar: Icon(
                        Icons.folder_outlined,
                        size: 16,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }),
                if (_tags.isNotEmpty)
                  Container(
                    width: 1,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).dividerColor,
                  ),
              ],
              
              // Tag filters
              ..._tags.map((tag) {
                final isSelected = notesProvider.selectedTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('#$tag'),
                    selected: isSelected,
                    onSelected: (selected) {
                      final selectedTags = List<String>.from(notesProvider.selectedTags);
                      if (selected) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                      notesProvider.filterByTags(selectedTags);
                    },
                    avatar: Icon(
                      Icons.tag,
                      size: 16,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }),
              
              // Clear filters button
              if (hasFilters)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ActionChip(
                    label: const Text('Clear'),
                    onPressed: () {
                      notesProvider.clearFilters();
                      _loadFilters(); // Reload to update available filters
                    },
                    avatar: const Icon(Icons.clear, size: 16),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

