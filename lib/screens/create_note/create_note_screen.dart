//TODO: Add Option to add Audio, Video, Picture.
//TODO: Add ASMRic sounds
// If the user has added audio, then note tile will have audio icon and similarly for others as well.
// Give an option to display image on Icons Position.

import 'package:flutter/material.dart';
import 'package:journal/models/note.dart';
import 'package:journal/repository/notes_repository.dart';
import 'package:journal/screens/Settings/Settings.dart';
import 'package:journal/utils.dart';

class CreateNoteScreen extends StatefulWidget {
  final Note? note;
  const CreateNoteScreen({super.key, this.note});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }

  _insert_note() async {
    print("Creating Note");
    final note = Note(
      title: _title.text,
      description: _description.text,
      created_at: DateTime.now(),
    );
    await NotesRepository.insert(note: note);
  }

  _update_note() async {
    final note = Note(
      id: widget.note!.id,
      title: _title.text,
      description: _description.text,
      created_at: widget.note!.created_at,
    );
    print("Updating Note");
    await NotesRepository.update(note: note);
  }

  //TODO: Add this to swipe to delete.
  _delete_note() async {
    await NotesRepository.delete(note: widget.note!).then((e) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    const vertical_gap = SizedBox(
      height: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Entry',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
        actions: [
          widget.note != null
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _delete_note();
                              },
                              child: const Text('Delete')),
                        ],
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                    child: Icon(Icons.delete),
                  ),
                )
              : const SizedBox(),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                    hintText: 'Tell me about your day!',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                maxLines: 15,
              ),
            ),
            vertical_gap,
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  hintText: 'Your day in 1 line',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            vertical_gap,
            vertical_gap,
            vertical_gap,
            vertical_gap,
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      get_video();
                    },
                    child: const Icon(
                      Icons.videocam,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      get_audio();
                    },
                    child: const Icon(
                      Icons.fiber_manual_record,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      get_image();
                    },
                    child: const Icon(
                      Icons.image,
                      size: 40,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { widget.note == null ? _insert_note() : _update_note();},
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.save),
      ),
    );
  }
}
