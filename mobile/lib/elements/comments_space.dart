import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/comment_tile.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';

/// Widget qui affiche l'espace de commentaires d'un événement
class CommentsSpace extends StatefulWidget {
  const CommentsSpace({super.key, required this.event});

  final Event event; // L'événement dont on veut afficher les commentaires

  @override
  State<CommentsSpace> createState() => _CommentSpaceState();
}

class _CommentSpaceState extends State<CommentsSpace> {
  final TextEditingController _comment = TextEditingController(); // Variable qui contient le commentaire à envoyer

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (context, eventsProvider, child) { // On utilise Consumer pour récupérer les commentaires
        return Column( 
          children: [
            const SizedBox(height: 16.0),
            const Text( 
              "Espace Commentaires",
              style: TextStyle(
                fontSize: 18.0, 
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField( // Champ pour écrire un commentaire
                    controller: _comment,
                    maxLength: 255,
                    decoration: InputDecoration(
                      hintText: 'Envoyer un message dans ${widget.event.title}',
                    ),
                  )
                ),
                IconButton( // Bouton pour envoyer le commentaire
                  onPressed: () async {
                    if (_comment.text.isNotEmpty && _comment.text.length <= 255) { // On vérifie que le commentaire n'est pas vide et qu'il ne dépasse pas 255 caractères
                      bool posted = await eventsProvider.postComment(widget.event.id, _comment.text); // On utilise la méthode postComment de EventsProvider pour envoyer le commentaire
                      if (!posted) { // Si le commentaire n'a pas été envoyé, on affiche un SnackBar pour prévenir l'utilisateur
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de l\'envoi du commentaire'),
                          ),
                        );
                      }
                      _comment.clear(); // On vide le champ de texte
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ]
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<List<Comment>>( 
              future: eventsProvider.getComments(widget.event.id), // On utilise la méthode getComments de EventsProvider pour récupérer les commentaires
              builder: (context, snapshot) {
                if (snapshot.hasData) { // Si les commentaires ont été récupérés
                  if (snapshot.data!.isEmpty) { // Si il n'y a pas de commentaires
                    return const Text("Aucun commentaire pour l'instant. Soyez le premier à en poster un !");
                  }
                  return SizedBox( // On affiche les commentaires dans une ListView
                    height: 300,
                    child: ListView.builder(                 
                      itemCount: snapshot.data!.length, // On affiche autant de CommentTile que de commentaires
                      itemBuilder: (context, index) { 
                        return CommentTile(comment: snapshot.data![index]); // On retourne un CommentTile avec le commentaire en paramètre
                      },
                    )
                  );
                } else if (snapshot.hasError) { // Si il y a eu une erreur lors de la récupération des commentaires
                  return const Text("Erreur lors de la récupération des commentaires",
                );
                } else { // Si les commentaires n'ont pas encore été récupérés
                  return const Center( // On affiche un Spinner
                    child: CircularProgressIndicator(),
                  );                  
                }
              }
            ),
          ],
        );
      }
    );
  }
}
