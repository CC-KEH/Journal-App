import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/todo.dart';
import 'package:journal/Todo/create_todo_screen.dart';
import 'package:journal/repository/todos_repository.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    const double listItemHeight = 80.0;
    bool iscompleted = false;

    markdone(){
      iscompleted = !iscompleted;
    }

    return Container(
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
          SizedBox(width: 10,),
          Icon(Icons.calendar_today_outlined),
          const SizedBox(width: 10),
          GestureDetector(
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    child: Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        // decoration: todo.isFinished.isOdd
                        //     ? TextDecoration.lineThrough
                        //     : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            '${DateFormat(DateFormat.DAY).format(todo.deadline)} ${DateFormat(DateFormat.ABBR_MONTH).format(todo.deadline)}}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w200,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
