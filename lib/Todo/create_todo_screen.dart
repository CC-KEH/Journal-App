import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/todo.dart';
import 'package:journal/notifiers/settings_notifier.dart';
import 'package:journal/repository/todos_repository.dart';
import 'package:journal/Settings/Settings.dart';
import 'package:journal/theme_notifier.dart';
import 'package:provider/provider.dart';

class CreateTodoScreen extends StatefulWidget {
  final Todo? todo;

  const CreateTodoScreen({super.key, this.todo});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _deadlineController = TextEditingController();
  final List<String> _subtasks = [];
  int _isFinished = 0;
  DateTime _deadline = DateTime.now();

  String _heading = 'New Task';

  @override
  void initState() {
    if (widget.todo != null) {
      _heading =
          '${DateFormat(DateFormat.DAY).format(widget.todo!.deadline)} ${DateFormat(DateFormat.ABBR_MONTH).format(widget.todo!.deadline)} ${widget.todo!.deadline.year.toString()}';
      _title.text = widget.todo!.title;
      _description.text = widget.todo!.description;
      _isFinished = widget.todo!.isFinished;
    }
    super.initState();
  }

  _insertTodo() async {
    final todo = Todo(
      title: _title.text,
      description: _description.text,
      deadline: _deadline, // Use your selected deadline
      isFinished: _isFinished,
      subtasks: _subtasks
          .map((subtaskTitle) => Subtask(title: subtaskTitle))
          .toList(), // Convert strings to List<Subtask>
    );
    await TodosRepository.insert(todo: todo);
  }

  _updateTodo() async {
    final todo = Todo(
      id: widget.todo!.id,
      title: _title.text,
      description: _description.text,
      deadline: widget.todo!.deadline,
      isFinished: _isFinished,
      subtasks: _subtasks
          .map((subtaskTitle) => Subtask(title: subtaskTitle))
          .toList(), // Convert to List<Subtask>
    );
    await TodosRepository.update(todo: todo);
  }

  _deleteTodo() async {
    await TodosRepository.delete(todo: widget.todo!).then((e) {
      Navigator.pop(context);
    });
  }

  _pickDeadline(BuildContext context) async {
    var pickedDeadline = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (pickedDeadline != null) {
      setState(() {
        _deadline = pickedDeadline;
        _deadlineController.text =
            DateFormat('yyyy-MM-dd').format(pickedDeadline);
      });
    }
  }

  _addSubtask() {
    setState(() {
      _subtasks.add('');
    });
  }

  _updateSubtask(int index, String value) {
    setState(() {
      _subtasks[index] = value;
    });
  }

  _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    const verticalGap = SizedBox(height: 20);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _heading,
          style: const TextStyle(fontSize: 32),
        ),
        centerTitle: true,
        actions: [
          widget.todo != null
              ? GestureDetector(
                  child: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteTodo();
                  })
              : const SizedBox(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  onThemeChanged: () =>
                      Provider.of<ThemeNotifier>(context, listen: false)
                          .notifyListeners(),
                ),
              ),
            ),
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
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
              cursorWidth: 2.0,
              cursorRadius: const Radius.circular(5.0),
            ),
            verticalGap,
            TextField(
              controller: _description,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 5,
              cursorColor: Theme.of(context).primaryColor,
              cursorWidth: 3.0,
              cursorRadius: const Radius.circular(5.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _addSubtask,
                child: Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: BoxDecoration(
                      color: Colors.teal[800],
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text('Add Subtask'),
                  ),
                ),
              ),
            ),
            // Display Subtasks List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < _subtasks.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeSubtask(i),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) => _updateSubtask(i, value),
                                decoration: InputDecoration(
                                  hintText: 'Subtask ${i + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            verticalGap,
            verticalGap,
            verticalGap,

            TextField(
              controller: _deadlineController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a deadline',
                prefix: InkWell(
                  onTap: () {
                    _pickDeadline(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.todo != null ? _updateTodo() : _insertTodo();
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
