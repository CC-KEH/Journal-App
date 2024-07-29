import 'package:flutter/material.dart';
import 'package:journal/constants.dart';
import 'package:journal/models/note.dart';
import 'package:journal/notifiers/settings_notifier.dart';
import 'package:journal/repository/notes_repository.dart';
import 'package:journal/Settings/Settings.dart';
import 'package:journal/Journal/create_note/create_note_screen.dart';
import 'package:journal/Journal/home/widgets/note_tile.dart';
import 'package:journal/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journal/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<JournalScreen> with RouteAware {
  bool _isSelectionMode = false;
  final Set<Note> _selectedNotes = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final settingsProvider =
    Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.setViewChange(prefs.getBool('isGridView') ?? false);
    settingsProvider.setTitlePosition(prefs.getBool('isTitleBelow') ?? true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {});
  }

  void _toggleSelection(Note note) {
    setState(() {
      if (_selectedNotes.contains(note)) {
        _selectedNotes.remove(note);
        if (_selectedNotes.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNotes.add(note);
        _isSelectionMode = true;
      }
    });
  }

  void _deleteSelectedNotes() async {
    for (var note in _selectedNotes) {
      await NotesRepository.delete(note: note);
    }
    setState(() {
      _selectedNotes.clear();
      _isSelectionMode = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
        actions: [
          if (_isSelectionMode)
            IconButton(
              onPressed: _deleteSelectedNotes,
              icon: const Icon(Icons.delete),
            ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  onThemeChanged: () =>
                      Provider.of<ThemeNotifier>(context, listen: false)
                          .notifyListeners(),
                ),
              ),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder(
        future: NotesRepository.get_notes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(journal_recommendation_text),
              );
            }
            if (settingsProvider.isGridView) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 70,horizontal: 0),
                child: CarouselSlider.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    final note = snapshot.data![itemIndex];
                    return GestureDetector(
                      onLongPress: () => _toggleSelection(note),
                      child: NoteTile(
                        note: note,
                        isSelected: _selectedNotes.contains(note),
                        isGridView: settingsProvider.isGridView,
                        isTitleBelow: settingsProvider.isTitleBelow,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 500.0, // Adjust height as needed
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  for (var note in snapshot.data!)
                    GestureDetector(
                      onLongPress: () => _toggleSelection(note),
                      child: NoteTile(
                        note: note,
                        isSelected: _selectedNotes.contains(note),
                        isGridView: settingsProvider.isGridView,
                        isTitleBelow: settingsProvider.isTitleBelow,
                      ),
                    )
                ],
              );
            }
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateNoteScreen(
                isTitleBelow: settingsProvider.isTitleBelow,
              ),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
