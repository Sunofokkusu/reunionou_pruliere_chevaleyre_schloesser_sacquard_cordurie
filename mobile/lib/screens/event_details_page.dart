import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/elements/comments_space.dart';
import 'package:reunionou/elements/event_form.dart';
import 'package:reunionou/elements/members_modal.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:reunionou/screens/home_page.dart';
import 'package:reunionou/elements/map_view_event.dart';

import 'event_form_page.dart';

// ignore: must_be_immutable
class EventDetailsPage extends StatefulWidget {
  EventDetailsPage({super.key, required this.event});

  late Event event;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: AutoSizeText(
            widget.event.title,
            minFontSize: 15.0,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text:
                        "http://localhost:8080/event/${widget.event.id}"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lien copié dans le presse-papier'),
                  ),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Consumer<EventsProvider>(
            builder: (context, events, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      "Programmé pour le  ${DateHelper.formatDate(widget.event.datetime)} à ${DateHelper.formatTime(widget.event.datetime)}",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Organisé par : ${widget.event.nameCreator}",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Contact : ${widget.event.emailCreator}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MembersModal(event: widget.event);
                              },
                            );
                          },
                          child: const Text('Voir les participants'),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, auth, child) {
                            if (auth.isLoggedIn && auth.user!.id == widget.event.idCreator) {
                              
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EventFormPage(
                                            event: widget.event,
                                          )
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Supprimer l'événement"),
                                            content: const Text("Êtes-vous sûr de vouloir supprimer cet événement ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Annuler"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  bool deleted = await events.deleteEvent(widget.event.id);
                                                  if (deleted) {
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Événement supprimé'),
                                                      ),
                                                    );
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => const  HomePage(),
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Erreur lors de la suppression de l\'événement'),
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
                                ]
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.event.desc,
                      style: const TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16.0),
                    Consumer<AuthProvider>(builder: (context, auth, child) {
                      if (auth.user!.id != widget.event.idCreator) {
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
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            fixedSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                40)),
                                        onPressed: () {},
                                        child: const Text('Désolé',
                                            style: TextStyle(fontSize: 18))),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                40)),
                                        child: const Text('J\'y serai !',
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () {}),
                                  ])
                            ])),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                    const SizedBox(height: 16.0),
                    MapView(
                      latitude: widget.event.lat,
                      longitude: widget.event.long,
                    ),
                    const SizedBox(height: 16.0),
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
}
