import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/elements/event_form.dart';
import 'package:reunionou/models/event.dart';

/// Page de création/modification d'un événement
// ignore: must_be_immutable
class EventFormPage extends StatefulWidget {
  EventFormPage({super.key, this.event});

  /// Evénement à modifier, null si création d'un nouvel événement
  late Event? event;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

/// Classe d'état de la page de création/modification d'un événement
class _EventFormPageState extends State<EventFormPage> {
  /// Méthode de création de la page de création/modification d'un événement
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // Titre changeant en fonction du paramètre event du widget
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
        // Affichage du formulaire d'événement
        body: EventForm(event: widget.event));
  }
}
