import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/comment.dart';

class MemberResponseTile extends StatefulWidget {
  const MemberResponseTile({super.key, required this.comment});

  final Comment comment;

  @override
  State<MemberResponseTile> createState() => _MemberResponseTileState();
}

class _MemberResponseTileState extends State<MemberResponseTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, builder, child) {
      int response = widget.comment.response!; // le nombre entre 0 et 2

      // Définir l'icône/couleur en fonction de la réponse
      IconData icon;
      Color bgColor;
      Color iconColor;
      switch (response) {
        case 1:
          icon = Icons.check_circle;
          bgColor = const Color.fromARGB(255, 172, 255, 175);
          iconColor = Colors.green;
          break;
        case 2:
          icon = Icons.cancel;
          bgColor = const Color.fromARGB(255, 255, 177, 172);
          iconColor = Colors.red;
          break;
        default:
          icon = Icons.schedule;
          bgColor = const Color.fromARGB(255, 220, 220, 220);
          iconColor = Colors.grey;
      }

      return Card(
        child: ListTile(
            title: Text(widget.comment.name),
            subtitle: Text(
              widget.comment.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.0),
            ),
            leading: Icon(
              icon,
              color: iconColor,
            ),
            tileColor: bgColor,
            onTap: () => {}),
      );
    });
  }
}
