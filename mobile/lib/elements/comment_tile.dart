import 'package:flutter/material.dart';
import 'package:reunionou/models/comment.dart';
import 'package:intl/intl.dart';

/// Widget qui affiche un commentaire
class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment; // Commentaire à afficher

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    String dateFormatted; // On initialise la variable qui va contenir la date
    DateTime date = widget.comment.createdAt.toLocal();
    if (date.day == DateTime.now().day) { // Si la date du commentaire est celle d'aujourd'hui
      dateFormatted = DateFormat('HH:mm').format(date); // On affiche l'heure
    } else { 
      dateFormatted = DateFormat('dd/MM/yyyy').format(date); // Sinon on affiche la date
    }
    return Card( // On retourne une Card
      child: ListTile(
        title: Text('${widget.comment.name} - $dateFormatted'), // On affiche le nom de l'utilisateur et la date
        subtitle: Text(
          widget.comment.comment, // On affiche le commentaire
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(height: 1.0),
        ),
      ),
    );
  }
}
