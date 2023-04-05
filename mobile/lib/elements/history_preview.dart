import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_details_page.dart';

/// Widget Tuile d'un événement dans l'historique
class HistoryPreview extends StatefulWidget {
  const HistoryPreview({super.key, required this.event});

  /// Evénement à afficher
  final Event event;

  @override
  State<HistoryPreview> createState() => _HistoryPreviewState();
}

/// State du widget
class _HistoryPreviewState extends State<HistoryPreview> {
  /// Construit le widget
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
      // Retourne une tuile avec le titre de l'événement, le nom de l'organisateur et une icône de suppression
      return ListTile(
          title: Text(widget.event.title),
          subtitle: Text(
            "Par ${widget.event.nameCreator}",
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            // Supprime l'événement de l'historique
            onPressed: () {
              eventsProvider.removeFromHistory(widget.event);
            },
          ),
          onTap: () async {
            Event? event = await eventsProvider.getEventById(widget.event.id);
            if (event == null) {
              eventsProvider.removeFromHistory(widget.event);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Impossible de récupérer l'événement"),
                ),
              );
              return;
            } else {
              var messages = await eventsProvider.getMessages(widget.event.id);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    EventDetailsPage(event: widget.event, messages: messages),
              ));
            }
          });
    });
  }
}
