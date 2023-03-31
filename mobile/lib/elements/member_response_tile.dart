import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/message.dart';

class MemberResponseTile extends StatefulWidget {
  const MemberResponseTile({super.key, required this.message});

  final Message message;

  @override
  State<MemberResponseTile> createState() => _MemberResponseTileState();
}

class _MemberResponseTileState extends State<MemberResponseTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, builder, child) {
      int status = widget.message.status; // le nombre entre 0 et 2

      // Définir l'icône/couleur en fonction de la réponse
      IconData icon;
      Color bgColor;
      Color iconColor;
      switch (status) {
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
        case 0:
          icon = Icons.schedule;
          bgColor = const Color.fromARGB(255, 220, 220, 220);
          iconColor = Colors.grey;
          break;
        default:
          icon = Icons.schedule;
          bgColor = const Color.fromARGB(255, 220, 220, 220);
          iconColor = Colors.grey;
      }

      return Card(
        child: ListTile(
            title: Text(widget.message.name),
            subtitle: widget.message.message == null
                ? const Text('')
                : Text(
                    widget.message.message!,
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
