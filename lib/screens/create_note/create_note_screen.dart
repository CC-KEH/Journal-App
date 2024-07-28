import 'package:flutter/material.dart';
import 'package:journal/models/note.dart';
import 'package:journal/notifiers/settings_notifier.dart';
import 'package:journal/repository/notes_repository.dart';
import 'package:journal/screens/Settings/Settings.dart';
import 'package:journal/utils.dart';
import 'package:journal/components/media_icon.dart';
import 'package:journal/theme_notifier.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  final Note? note;
  final bool isTitleBelow;

  const CreateNoteScreen({
    super.key,
    this.note,
    required this.isTitleBelow,
  });

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String? _imagePath;
  String? _videoPath;
  String? _audioPath;

  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
      _imagePath = widget.note!.imagePath;
      _videoPath = widget.note!.videoPath;
      _audioPath = widget.note!.audioPath;
    }
    super.initState();
  }

  _insert_note() async {
    final note = Note(
      title: _title.text,
      description: _description.text,
      created_at: DateTime.now(),
      imagePath: _imagePath,
      videoPath: _videoPath,
      audioPath: _audioPath,
    );
    await NotesRepository.insert(note: note);
  }

  _update_note() async {
    final note = Note(
      id: widget.note!.id,
      title: _title.text,
      description: _description.text,
      created_at: widget.note!.created_at,
      imagePath: _imagePath,
      videoPath: _videoPath,
      audioPath: _audioPath,
    );
    await NotesRepository.update(note: note);
  }

  _delete_note() async {
    await NotesRepository.delete(note: widget.note!).then((e) {
      Navigator.pop(context);
    });
  }

  Future<void> showMediaOptionsDialog({
    required BuildContext context,
    required String mediaType,
    required Function() onRecord,
    required Function() onUpload,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $mediaType Option'),
          content: Text(
              'Would you like to record a $mediaType or upload an existing one?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRecord();
              },
              child: Text('Record $mediaType'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onUpload();
              },
              child: Text('Upload $mediaType'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMediaOptions(
      String mediaType, Function() onRecord, Function() onUpload) async {
    await showMediaOptionsDialog(
      context: context,
      mediaType: mediaType,
      onRecord: onRecord,
      onUpload: onUpload,
    );
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final path = await get_image(fromCamera: fromCamera);
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _pickVideo({bool fromCamera = false}) async {
    final path = await get_video(fromCamera: fromCamera);
    if (path != null) {
      setState(() {
        _videoPath = path;
      });
    }
  }

  Future<void> _handleAudio({bool recordAudio = false}) async {
    final path = await handle_audio(recordAudio: recordAudio);
    if (path != null) {
      setState(() {
        _audioPath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const vertical_gap = SizedBox(height: 20);
    final settingsProvider = Provider.of<SettingsProvider>(context);

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
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _delete_note();
                            },
                            child: const Text('Delete'),
                          ),
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                          onThemeChanged: () =>
                              Provider.of<ThemeNotifier>(context, listen: false)
                                  .notifyListeners(),
                        ))),
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
            if (!settingsProvider.isTitleBelow) ...[
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: 'Your day in 1 line',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 2.0,
                cursorRadius: const Radius.circular(5.0),
              ),
              vertical_gap,
            ],
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Tell me about your day!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 15,
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 3.0,
                cursorRadius: const Radius.circular(5.0),
              ),
            ),
            vertical_gap,
            if (settingsProvider.isTitleBelow) ...[
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: 'Your day in 1 line',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 2.0,
                cursorRadius: const Radius.circular(5.0),
              ),
              vertical_gap,
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imagePath != null
                      ? MediaItem(
                          filePath: _imagePath!,
                          mediaType: 'image',
                          onDelete: () {
                            setState(() {
                              _imagePath = null;
                            });
                          },
                          onView: () {
                            // Implement image viewing functionality here
                          },
                        )
                      : GestureDetector(
                          onTap: () => _showMediaOptions(
                            'Image',
                            () => _pickImage(fromCamera: true),
                            () => _pickImage(),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                  _videoPath != null
                      ? MediaItem(
                          filePath: _videoPath!,
                          mediaType: 'video',
                          onDelete: () {
                            setState(() {
                              _videoPath = null;
                            });
                          },
                          onView: () {
                            // Implement video viewing functionality here
                          },
                        )
                      : GestureDetector(
                          onTap: () => _showMediaOptions(
                            'Video',
                            () => _pickVideo(fromCamera: true),
                            () => _pickVideo(),
                          ),
                          child: const Icon(
                            Icons.videocam,
                            size: 40,
                          ),
                        ),
                  _audioPath != null
                      ? MediaItem(
                          filePath: _audioPath!,
                          mediaType: 'audio',
                          onDelete: () {
                            setState(() {
                              _audioPath = null;
                            });
                          },
                          onView: () {
                            // Implement audio playback functionality here
                          },
                        )
                      : GestureDetector(
                          onTap: () => _showMediaOptions(
                            'Audio',
                            () => _handleAudio(recordAudio: true),
                            () => _handleAudio(),
                          ),
                          child: const Icon(
                            Icons.audiotrack,
                            size: 40,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.note != null ? _update_note() : _insert_note();
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
