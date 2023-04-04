import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/comment_tile.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';

/// TODO : Julien explique
class CommentsSpace extends StatefulWidget {
  const CommentsSpace({super.key, required this.event});

  final Event event;

  @override
  State<CommentsSpace> createState() => _CommentSpaceState();
}

class _CommentSpaceState extends State<CommentsSpace> {
  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
      return Column(
        children: [
          const SizedBox(height: 16.0),
          const Text(
            "Espace Commentaires",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            Expanded(
                child: TextField(
              controller: _comment,
              maxLength: 255,
              decoration: InputDecoration(
                hintText: 'Envoyer un message dans ${widget.event.title}',
              ),
            )),
            IconButton(
              onPressed: () async {
                if (_comment.text.isNotEmpty && _comment.text.length <= 255) {
                  bool posted = await eventsProvider.postComment(
                      widget.event.id, _comment.text);
                  if (!posted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de l\'envoi du commentaire'),
                      ),
                    );
                  }
                  _comment.clear();
                }
              },
              icon: const Icon(Icons.send),
            ),
          ]),
          const SizedBox(height: 16.0),
          FutureBuilder<List<Comment>>(
            future: eventsProvider.getComments(widget.event.id),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Text(
                      "Aucun commentaire pour l'instant. Soyez le premier à en poster un !");
                }
                return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CommentTile(comment: snapshot.data![index]);
                      },
                    ));
              } else if (snapshot.hasError) {
                return const Text(
                  "Erreur lors de la récupération des commentaires",
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ],
      );
    });
  }
}
