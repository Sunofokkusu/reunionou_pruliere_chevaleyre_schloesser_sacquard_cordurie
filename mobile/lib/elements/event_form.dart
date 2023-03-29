import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/screens/home_page.dart';

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
  late String place = widget.event?.place ?? "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, builder, child) {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25.0),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.event?.title ?? "",
                  decoration: const InputDecoration(
                    labelText: "Titre*",
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Champ obligatoire"
                      : null,
                ),
                TextFormField(
                  initialValue: widget.event?.desc ?? "",
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                  onChanged: (value) {
                    setState(() {
                      desc = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: widget.event?.place ?? "",
                  decoration: const InputDecoration(
                    labelText: "Lieu*",
                  ),
                  onChanged: (value) {
                    setState(() {
                      place = value;
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Champ obligatoire"
                      : null,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width / 4, 40),
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
                      Container(
                        margin: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          DateHelper.formatDateTime(datetime),
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: (widget.event == null
                                        ? const Text("Événement ajoutée")
                                        : const Text("Événement modifiée")),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }

                              // if (widget.event == null) {
                              //   builder.addTask(Event(title, desc));
                              // } else {
                              //   widget.event!.title = title;
                              //   widget.event!.desc = desc;
                              //   builder.updateTask(widget.event!);
                              // }

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text("Enregistrer")),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}