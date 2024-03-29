import 'dart:convert';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/providers/map_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/screens/event_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/elements/map_modal.dart';

/// Widget Tuile d'un événement
class EventForm extends StatefulWidget {
  const EventForm({super.key, this.event});

  /// Evénement à afficher
  final Event? event;

  @override
  State<EventForm> createState() => _EventFormState();
}

/// State du widget
class _EventFormState extends State<EventForm> {
  // Champs du formulaire
  late String title = widget.event?.title ?? "";
  late String desc = widget.event?.desc ?? "";
  late DateTime datetime = widget.event?.datetime ?? DateTime.now();
  late String adress = widget.event?.adress ?? "";
  late double lat = widget.event?.lat ?? 0.0;
  late double long = widget.event?.long ?? 0.0;
  final _formKey = GlobalKey<FormState>();
  // Résultat de la requête
  late String? newCreatedId;
  late Event? newCreatedEvent;

  /// Construit le widget
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
      // Retourne un formulaire permettant de créer ou modifier un événement
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25.0),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    // Titre
                    TextFormField(
                        initialValue: title,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          labelText: "Titre*",
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire";
                          } else if (value.length < 3) {
                            return "Le titre doit contenir au moins 3 caractères";
                          } else {
                            return null;
                          }
                        }),
                    // Date et heure
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 4, 40),
                            ),
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(), onConfirm: (date) {
                                setState(() {
                                  datetime = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.fr);
                            },
                            child: const Text(
                              'Choisir une date',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // Valeur de la date
                          Text(
                            DateHelper.formatDateTime(datetime),
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Description
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          minHeight: 60.0, maxHeight: 180.0),
                      child: TextFormField(
                        initialValue: desc,
                        maxLines: null,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          labelText: "Description",
                        ),
                        onChanged: (value) {
                          setState(() {
                            desc = value;
                          });
                        },
                      ),
                    ),
                    // Adresse
                    TextFormField(
                        key: Key(Provider.of<MapProvider>(context).adress!),
                        initialValue: adress,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: "Adresse*",
                        ),
                        onChanged: (value) {
                          setState(() {
                            adress = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire";
                          } else if (value.length < 3) {
                            return "Le titre doit contenir au moins 3 caractères";
                          } else {
                            return null;
                          }
                        }),
                    // Boutons de localisation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              if (adress != "") {
                                var response = await http.get(Uri.parse(
                                    "https://api-adresse.data.gouv.fr/search/?q=$adress"));
                                if (response.statusCode == 200) {
                                  Map<String, dynamic> data =
                                      jsonDecode(response.body);
                                  setState(() {
                                    try {
                                      lat = data["features"][0]["geometry"]
                                          ["coordinates"][1];
                                      long = data["features"][0]["geometry"]
                                          ["coordinates"][0];
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Localisation réussie')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Localisation impossible')));
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Une erreur est survenue')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: adress == ""
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 221, 96, 255)),
                            child: const Text("Localiser sur la carte")),
                        // Bouton de localisation sur la carte
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: [
                                        MapModal(
                                          latitude: lat,
                                          longitude: long,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                                lat = Provider.of<MapProvider>(
                                                        context,
                                                        listen: false)
                                                    .lat!;
                                                long = Provider.of<MapProvider>(
                                                        context,
                                                        listen: false)
                                                    .long!;
                                                adress =
                                                    Provider.of<MapProvider>(
                                                            context,
                                                            listen: false)
                                                        .adress!;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              // define the width of the button in the dialog at the width of the dialog
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  40),
                                            ),
                                            child: const Text("Valider"))
                                      ],
                                    );
                                  });
                            },
                            child: const Text("Ajouter depuis la carte")),
                      ],
                    ),
                  ]),
                  // Bouton de validation
                  ElevatedButton(
                      onPressed: () async {
                        // Si le formulaire est invalide, les valiateurs renvoient des messages d'erreur
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        // Si le formulaire est valide
                        else {
                          // On affiche un message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: (widget.event == null
                                  ? const Text("Événement ajouté")
                                  : const Text("Événement modifié")),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }

                        // On l'ajoute ou on le modifie
                        if (widget.event == null) {
                          newCreatedId = await eventsProvider.createEvent(title,
                              desc, datetime.toString(), adress, lat, long);
                          newCreatedEvent =
                              await eventsProvider.getEventById(newCreatedId!);
                          if (newCreatedEvent != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: newCreatedEvent!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text("Erreur lors de la création"),
                              ),
                            );
                          }
                        } else {
                          widget.event!.title = title;
                          widget.event!.desc = desc;
                          widget.event!.datetime = datetime;
                          widget.event!.adress = adress;
                          widget.event!.lat = lat;
                          widget.event!.long = long;
                          bool updated =
                              await eventsProvider.updateEvent(widget.event!);
                          if (updated) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailsPage(event: widget.event!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    "Erreur lors de la modification"),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor:
                            (lat == 0.0 || long == 0.0 || title == "")
                                ? Colors.grey
                                : Color.fromARGB(255, 140, 24, 172),
                      ),
                      child: const Text("Enregistrer"))
                ]),
          ),
        ),
      );
    });
  }
}
