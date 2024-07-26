class Note {
  int? id;
  String title, description;
  DateTime created_at;
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.created_at,
  });

  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'description':description,
      'created_at':created_at.toString(),
    };
  }
}
