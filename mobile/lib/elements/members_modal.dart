import 'package:flutter/material.dart';
import 'package:reunionou/elements/member_response_tile.dart';
import 'package:reunionou/models/message.dart';

/// Widget Modale affichant la liste des participants à un événement
class MembersModal extends StatefulWidget {
  MembersModal({Key? key, required this.messages}) : super(key: key);

  /// Liste des participants à l'événement
  List<Message> messages;

  @override
  _MembersModalState createState() => _MembersModalState();
}

/// Classe d'état du widget Modale
class _MembersModalState extends State<MembersModal> {
  bool _modalOpen = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: screenHeight * 0.8,
        width: screenWidth * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.55,
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return MemberResponseTile(
                    message: widget.messages.elementAt(index),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: close,
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void close() {
    setState(() {
      _modalOpen = false;
    });
    Navigator.of(context).pop();
  }

  void open() {
    setState(() {
      _modalOpen = true;
    });
  }
}
