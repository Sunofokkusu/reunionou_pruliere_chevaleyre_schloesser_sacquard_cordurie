import 'package:flutter/material.dart';
import 'package:reunionou/models/comment.dart';
import 'package:intl/intl.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  @override
  Widget build(BuildContext context) {
    String dateFormatted;
    DateTime date = widget.comment.createdAt.toLocal();
    if (date.day == DateTime.now().day) {
      dateFormatted = DateFormat('HH:mm').format(date);
    } else {
      dateFormatted = DateFormat('dd/MM/yyyy').format(date);
    }
    return Card(
      child: ListTile(
        title: Text('${widget.comment.name} - $dateFormatted'),
        subtitle: Text(
          widget.comment.comment,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(height: 1.0),
        ),
      ),
    );
  }
}