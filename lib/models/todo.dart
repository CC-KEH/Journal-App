class Subtask {
  int? id; // Optional: If you need unique IDs for subtasks
  String title;
  bool isCompleted;

  Subtask({this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Subtask fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class Todo {
  int? id;
  String title;
  String description;
  DateTime deadline;
  int isFinished;
  List<Subtask> subtasks; // New field

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isFinished,
    this.subtasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toString(),
      'isFinished': isFinished,
      'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(), // New field in map conversion
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: DateTime.parse(map['deadline']),
      isFinished: int.parse(map['isFinished']),
      subtasks: (map['subtasks'] as List)
          .map((subtask) => Subtask.fromMap(subtask))
          .toList(),
    );
  }
}
