import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/note.dart';
import 'package:journal/screens/create_note/create_note_screen.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final bool isGridView;
  final bool isTitleBelow;
  final bool isSelected;

  const NoteTile({
    super.key,
    required this.isSelected,
    required this.note,
    required this.isGridView,
    required this.isTitleBelow,
  });

  @override
  Widget build(BuildContext context) {
    const double listItemHeight = 80.0;
    const double gridItemHeight = 150.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateNoteScreen(
              note: note,
              isTitleBelow: isTitleBelow,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: isGridView ? gridItemHeight : listItemHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(5),
        child: isGridView
            ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Text(
                        note.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat(DateFormat.DAY).format(note.created_at)} ${DateFormat(DateFormat.ABBR_MONTH).format(note.created_at)} ${note.created_at.year.toString()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat(DateFormat.HOUR_MINUTE).format(note.created_at),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
            )
            : Row(
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
                        DateFormat(DateFormat.HOUR_MINUTE)
                            .format(note.created_at),
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
