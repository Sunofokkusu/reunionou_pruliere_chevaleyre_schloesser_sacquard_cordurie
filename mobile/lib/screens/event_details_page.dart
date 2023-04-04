import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/elements/comments_space.dart';
import 'package:reunionou/elements/members_modal.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:reunionou/models/message.dart';

// ignore: must_be_immutable
class EventDetailsPage extends StatefulWidget {
  EventDetailsPage({super.key, required this.event, this.messages = const []});

  late Event event;
  late List<Message> messages;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late String message = "";
  static const messageStatus = {
    "Pending": 0,
    "Accepted": 1,
    "Refused": 2,
  };
  bool hasSentParticipation = false;

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
                    const SizedBox(height: 16.0),
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
                    const SizedBox(height: 16.0),
                    Text(
                      widget.event.desc,
                      style: const TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16.0),
                    Consumer<AuthProvider>(builder: (context, auth, child) {
                      final participantButtonSize =
                          Size(MediaQuery.of(context).size.width * 0.3, 40);
                      if (isntCreatorOrParticipant(auth.user!.id)) {
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
                                            fixedSize: participantButtonSize),
                                        onPressed: () async {
                                          sendFormParticipant(
                                              auth.user!.id,
                                              events,
                                              messageStatus["Refused"]!);
                                        },
                                        child: const Text('Désolé',
                                            style: TextStyle(fontSize: 18))),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: participantButtonSize),
                                        child: const Text('J\'y serai !',
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () async {
                                          sendFormParticipant(
                                              auth.user!.id,
                                              events,
                                              messageStatus["Accepted"]!);
                                        }),
                                  ])
                            ])),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
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

  bool isntCreatorOrParticipant(String idUserLogged) {
    return (idUserLogged != widget.event.idCreator &&
        !widget.messages.any((element) => element.idAuthor == idUserLogged));
  }

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
