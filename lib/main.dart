import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/notes_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize preferences service
  final preferencesService = PreferencesService();
  await preferencesService.incrementAppLaunchCount();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Notes App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    // Initialize theme
    await themeProvider.initializeTheme();
    
    // Load notes
    await notesProvider.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

