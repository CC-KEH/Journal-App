class Todo {
  int? id;
  String title, description;
  DateTime deadline;
  int isFinished;
  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isFinished,
  });

  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'description':description,
      'deadline':deadline.toString(),
      'isFinished':isFinished.toString(),
    };
  }
}
