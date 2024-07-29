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
  final _deadline_controller = TextEditingController();
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

  _insert_todo() async {
    final todo = Todo(
      title: _title.text,
      description: _description.text,
      deadline: DateTime.now(),
      isFinished: _isFinished,
    );
    await TodosRepository.insert(todo: todo);
  }

  _update_todo() async {
    final todo = Todo(
      id: widget.todo!.id,
      title: _title.text,
      description: _description.text,
      deadline: widget.todo!.deadline,
      isFinished: _isFinished,
    );
    await TodosRepository.update(todo: todo);
  }

  _delete_todo() async {
    // Instead of doing this send it to Completed Tasks
    await TodosRepository.delete(todo: widget.todo!).then((e) {
      Navigator.pop(context);
    });
  }

  _pick_deadline(BuildContext context) async {
    var _picked_deadline = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (_picked_deadline != null) {
      setState(() {
        _deadline = _picked_deadline;
        _deadline_controller.text =
            DateFormat('yyyy-mm-dd').format(_picked_deadline);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const vertical_gap = SizedBox(height: 20);
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
                    _delete_todo();
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
            vertical_gap,
            Expanded(
              child: TextField(
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
            ),
            vertical_gap,
            TextField(
              controller: _deadline_controller,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a deadline',
                prefix: InkWell(
                  onTap: () {
                    _pick_deadline(context);
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
          widget.todo != null ? _update_todo() : _insert_todo();
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
