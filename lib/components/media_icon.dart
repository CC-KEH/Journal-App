import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class MediaItem extends StatelessWidget {
  final String filePath;
  final String mediaType; // "video", "image", or "audio"
  final Function onDelete;
  final Function onView;

  MediaItem({
    required this.filePath,
    required this.mediaType,
    required this.onDelete,
    required this.onView,
  });

  IconData _getIcon() {
    switch (mediaType) {
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      case 'audio':
        return Icons.audiotrack;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('View/Play'),
                    onTap: () {
                      Navigator.pop(context);
                      onView();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        _getIcon(),
        color: Colors.green, // Color the icon green after uploading
        size: 50,
      ),
    );
  }
}
