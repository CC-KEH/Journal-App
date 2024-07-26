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
    const horizontal_gap = SizedBox(width: 20);
    const list_item_height = 80.0;
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
            //  Icon, TODO: Show Image here
            const Icon(
              Icons.note_alt_outlined,
              size: 30,
            ),
            horizontal_gap,
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    //TODO: Fix the overflow issue
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
            //  Date
            horizontal_gap,
            horizontal_gap,
            horizontal_gap,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat(DateFormat.DAY).format(note.created_at)} ${DateFormat(DateFormat.ABBR_MONTH).format(note.created_at)} ${note.created_at.year.toString()}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey),
                ),
                Text(
                  DateFormat(DateFormat.HOUR_MINUTE).format(note.created_at),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
