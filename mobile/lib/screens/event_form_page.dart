import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/event_form.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/event.dart';

// ignore: must_be_immutable
class EventFormPage extends StatefulWidget {
  EventFormPage({super.key, this.event});

  late Event? event;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: widget.event == null
              ? const Text("Nouvelle événement")
              : const Text("Modifier l'événement"),
        ),
        body: Consumer<EventsProvider>(builder: (context, builder, child) {
          return EventForm(event: widget.event);
        }));
  }
}
