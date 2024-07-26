import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/note.dart';
import 'package:journal/screens/create_note/create_note_screen.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  const NoteTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    const double list_item_height = 80.0;
    const Color list_item_color = Color(0xffffffff);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateNoteScreen(
              note: note,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: list_item_height,
        decoration: BoxDecoration(
          color: list_item_color,
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
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.description,
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
                  '${DateFormat(DateFormat.DAY).format(note.created_at)} ${DateFormat(DateFormat.ABBR_MONTH).format(note.created_at)} ${note.created_at.year.toString()}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat(DateFormat.HOUR_MINUTE).format(note.created_at),
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
