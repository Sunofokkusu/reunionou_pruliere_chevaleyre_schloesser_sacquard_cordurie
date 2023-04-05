import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_details_page.dart';

/// Widget Tuile d'un événement
class EventPreview extends StatefulWidget {
  const EventPreview({super.key, required this.event});

  /// Evénement à afficher
  final Event event;

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

/// State du widget
class _EventPreviewState extends State<EventPreview> {
  /// Construit le widget
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
      // Retourne une tuile avec le titre de l'événement, la description et la date de l'événement
      return ListTile(
          title: Row(
            children: [
              // Le titre est affiché en premier
              Text(widget.event.title),
              const Spacer(),
              // La date est affichée en petit à droite du titre
              Text(DateHelper.formatDateTime(widget.event.datetime),
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
          // La description de 3 lignes maximum est affichée en dessous du titre
          subtitle: Text(
            widget.event.desc,
            maxLines: widget.event.desc.isEmpty ? null : 3,
            overflow: TextOverflow.ellipsis,
          ),
          tileColor: widget.event.isPast() ? Colors.grey[300] : null,
          // Lorsque l'on clique sur la tuile, on affiche la page de détails de l'événement
          onTap: () async {
            var messages = await eventsProvider.getMessages(widget.event.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    EventDetailsPage(event: widget.event, messages: messages),
              ),
            );
          });
    });
  }
}
