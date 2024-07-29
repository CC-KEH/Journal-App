import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/todo.dart';
import 'package:journal/Todo/create_todo_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    const double listItemHeight = 80.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateTodoScreen(
              todo: todo,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: listItemHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Icon(
              Icons.note_alt_outlined,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${DateFormat(DateFormat.DAY).format(todo.deadline)} ${DateFormat(DateFormat.ABBR_MONTH).format(todo.deadline)}}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat(DateFormat.HOUR_MINUTE)
                      .format(todo.deadline),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
