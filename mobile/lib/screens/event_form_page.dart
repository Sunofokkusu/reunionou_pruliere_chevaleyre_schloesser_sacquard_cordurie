import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/event_form.dart';
import 'package:reunionou/provider/events_provider.dart';
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
          title: AutoSizeText(
            widget.event == null
                ? ("Nouvel événement")
                : ("Modifier l'événement"),
            minFontSize: 15.0,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: Consumer<EventsProvider>(builder: (context, builder, child) {
          return EventForm(event: widget.event);
        }));
  }
}
