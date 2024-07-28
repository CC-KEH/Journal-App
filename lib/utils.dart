import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

Future<String?> _getAppDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String?> get_image({bool fromCamera = false}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
  if (pickedFile != null) {
    final appDir = await _getAppDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedImage = await File(pickedFile.path).copy('$appDir/$fileName');
    return savedImage.path;
  }
  return null;
}

Future<String?> get_video({bool fromCamera = false}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickVideo(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
  if (pickedFile != null) {
    final appDir = await _getAppDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedVideo = await File(pickedFile.path).copy('$appDir/$fileName');
    return savedVideo.path;
  }
  return null;
}

Future<String?> handle_audio({bool recordAudio = false}) async {
  final appDir = await _getAppDirectory();
  String? filePath;

  if (recordAudio) {
    // Initialize the audio recorder (make sure to do this in your class or use a singleton pattern)
    final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

    // Check if the recorder is already recording
    if (_audioRecorder.isRecording) {
      // Stop recording
      filePath = await _audioRecorder.stopRecorder();
      final file = File(filePath!);
      final savedFile = await file.copy('$appDir/${path.basename(filePath)}');
      filePath = savedFile.path;
    } else {
      // Start recording
      final tempPath = '$appDir/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder.startRecorder(toFile: tempPath);
      filePath = tempPath;
    }
  } else {
    // Pick audio file
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final fileName = path.basename(result.files.single.path!);
      final pickedFile = File(result.files.single.path!);
      final savedFile = await pickedFile.copy('$appDir/$fileName');
      filePath = savedFile.path;
    }
  }
  return filePath;
}