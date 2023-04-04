import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/elements/comments_space.dart';
import 'package:reunionou/elements/members_modal.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:reunionou/models/message.dart';
import 'package:reunionou/screens/home_page.dart';
import 'package:reunionou/elements/map_view_event.dart';

import 'event_form_page.dart';

/// Page de détails d'un événement, affichant les informations de l'événement mais ne permettant pas de le modifier
// ignore: must_be_immutable
class EventDetailsPage extends StatefulWidget {
  EventDetailsPage({super.key, required this.event, this.messages = const []});

  /// Evénement à afficher
  late Event event;

  /// Liste des messages de participation à l'événement, à obtenir en amont pour décider d'une partie de l'affichage
  late List<Message> messages;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

/// Classe d'état de la page de détails d'un événement
class _EventDetailsPageState extends State<EventDetailsPage> {
  /// message de participation à l'événement
  late String message = "";

  /// Statut de participation à l'événement
  static const messageStatus = {
    "Pending": 0,
    "Accepted": 1,
    "Refused": 2,
  };

  /// Indique si l'utilisateur a déjà envoyé une participation à l'événement, évite les doublons pendant le temps de réponse de l'API
  bool hasSentParticipation = false;

  /// Méthode de création de la page de détails d'un événement
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Titre d'appbar correpsondant au titre de l'événement
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: AutoSizeText(
            widget.event.title,
            minFontSize: 12.0,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          // Bouton de modification de l'événement copiant l'URL de l'événement dans le presse-papier
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text: "http://localhost:8080/event/${widget.event.id}"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lien copié dans le presse-papier'),
                  ),
                );
              },
            )
          ],
        ),
        // Contenu de la page scrollable
        body: SingleChildScrollView(
          child: Consumer<EventsProvider>(
            builder: (context, eventsProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    // Date de l'événement
                    Text(
                      "Programmé pour le  ${DateHelper.formatDate(widget.event.datetime)} à ${DateHelper.formatTime(widget.event.datetime)}",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    // Nom et mail de l'organisateur
                    Text(
                      "Organisé par : ${widget.event.nameCreator}",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Contact : ${widget.event.emailCreator}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    // Barre d'actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 16.0),
                        // Affiche la liste des participants
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MembersModal(messages: widget.messages);
                              },
                            );
                          },
                          child: const Text('Voir les participants'),
                        ),
                        // Icones réservées à l'organisateur
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            if (authProvider.isLoggedIn &&
                                authProvider.user!.id ==
                                    widget.event.idCreator) {
                              return Row(children: [
                                // Modification de l'événement
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => EventFormPage(
                                                event: widget.event,
                                              )),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                // Suppression de l'événement
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          // Affichage d'une boite de dialogue de confirmation pour la suppression de l'événement
                                          title: const Text(
                                              "Supprimer l'événement"),
                                          content: const Text(
                                              "Êtes-vous sûr de vouloir supprimer cet événement ?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Annuler"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                bool deleted =
                                                    await eventsProvider
                                                        .deleteEvent(
                                                            widget.event.id);
                                                // Si suppression réussie, affichage d'un message de confirmation et retour à la page d'accueil
                                                if (deleted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Événement supprimé'),
                                                    ),
                                                  );
                                                  Navigator.of(context)
                                                    ..pop()
                                                    ..push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomePage(),
                                                      ),
                                                    )
                                                    ..pop()
                                                    ..pop();
                                                }
                                                // Si suppression échouée, affichage d'un message d'erreur
                                                else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Erreur lors de la suppression de l\'événement'),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: const Text("Supprimer"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                )
                              ]);
                            }
                            // Si l'utilisateur n'est pas l'organisateur, cette partie de la page est vide
                            else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Description de l'événement
                    widget.event.desc.isNotEmpty
                        ? Text(
                            widget.event.desc,
                            style: const TextStyle(
                                fontSize: 16.0, fontStyle: FontStyle.italic),
                          )
                        : Container(),
                    widget.event.desc.isNotEmpty
                        ? const SizedBox(height: 16.0)
                        : Container(),
                    // Carte embarquée, lieu de l'événement
                    MapView(
                      latitude: widget.event.lat,
                      longitude: widget.event.long,
                    ),
                    const SizedBox(height: 16.0),
                    // Section de message de participation
                    Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                      /// Taille des boutons de participation
                      final participantButtonSize =
                          Size(MediaQuery.of(context).size.width * 0.3, 40);
                      // Si l'utilisateur n'est pas le créateur de l'événement et qu'il n'a pas déjà répondu
                      if (isntCreatorOrParticipant(authProvider.user!.id)) {
                        // Bordures pour séparer la section
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                child: Column(children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 60.0, maxHeight: 180.0),
                                // Champ de message optionnel
                                child: TextFormField(
                                  initialValue: message,
                                  maxLength: 200,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText: "Message optionnel",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      message = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Bouton de refus
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          fixedSize: participantButtonSize),
                                      child: const Text('Désolé',
                                          style: TextStyle(fontSize: 18)),
                                      onPressed: () async {
                                        sendFormParticipant(
                                            authProvider.user!.id,
                                            eventsProvider,
                                            messageStatus["Refused"]!);
                                      },
                                    ),
                                    // Bouton de participation
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: participantButtonSize),
                                        child: const Text('J\'y serai !',
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () async {
                                          sendFormParticipant(
                                              authProvider.user!.id,
                                              eventsProvider,
                                              messageStatus["Accepted"]!);
                                        }),
                                  ])
                            ])),
                          ),
                        );
                      }
                      // Si l'utilisateur est le créateur de l'événement, ou qu'il a déjà répondu, cette partie de la page est vide
                      else {
                        return Container();
                      }
                    }),
                    const SizedBox(height: 16.0),
                    // Espace de commentaire
                    CommentsSpace(
                      event: widget.event,
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  /// Méthode qui retourne true si l'utilisateur n'est pas le créateur de l'événement et qu'il n'a pas déjà répondu au formulaire de participation
  bool isntCreatorOrParticipant(String idUserLogged) {
    return (idUserLogged != widget.event.idCreator &&
        !widget.messages.any((element) => element.idAuthor == idUserLogged));
  }

  /// Méthode qui envoie le formulaire de participation
  void sendFormParticipant(
      String idUserLogged, EventsProvider events, int status) async {
    if (!hasSentParticipation) {
      hasSentParticipation = true;
      if (isntCreatorOrParticipant(idUserLogged)) {
        await events.postMessage(widget.event, message, status);
        var newMessages = await events.getMessages(widget.event.id);
        setState(() {
          widget.messages = newMessages;
          message = "";
        });
      }
    }
  }
}
