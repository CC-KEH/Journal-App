class Note {
  int? id;
  String title, description;
  String? imagePath,audioPath,videoPath;
  DateTime created_at;
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.created_at,
    this.imagePath,
    this.videoPath,
    this.audioPath,
  });

  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'description':description,
      'created_at':created_at.toString(),
    };
  }
}
