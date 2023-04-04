import 'dart:convert';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/providers/map_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/screens/event_details_page.dart';
import 'package:reunionou/screens/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/elements/map_modal.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key, this.event});

  final Event? event;

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late String title = widget.event?.title ?? "";
  late String desc = widget.event?.desc ?? "";
  late DateTime datetime = widget.event?.datetime ?? DateTime.now();
  late String adress = widget.event?.adress ?? "";
  late double lat = widget.event?.lat ?? 0.0;
  late double long = widget.event?.long ?? 0.0;
  final _formKey = GlobalKey<FormState>();
  late String? newCreatedId;
  late Event? newCreatedEvent;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
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
                                    lat = data["features"][0]["geometry"]
                                        ["coordinates"][1];
                                    long = data["features"][0]["geometry"]
                                        ["coordinates"][0];
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Localisation réussie')),
                                  );
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
                  ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: (widget.event == null
                                  ? const Text("Événement ajouté")
                                  : const Text("Événement modifié")),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }

                        if (widget.event == null) {
                          newCreatedId = await eventsProvider.createEvent(title,
                              desc, datetime.toString(), adress, lat, long);
                          newCreatedEvent =
                              await eventsProvider.getEventById(newCreatedId!);
                        } else {
                          // widget.event!.title = title;
                          // widget.event!.desc = desc;
                          // eventsProvider.updateTask(widget.event!);
                        }

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
