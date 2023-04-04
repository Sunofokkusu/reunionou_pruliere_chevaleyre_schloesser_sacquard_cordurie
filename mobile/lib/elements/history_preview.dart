import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_details_page.dart';

class HistoryPreview extends StatefulWidget {
  const HistoryPreview({super.key, required this.event});

  final Event event;

  @override
  State<HistoryPreview> createState() => _HistoryPreviewState();
}

class _HistoryPreviewState extends State<HistoryPreview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, builder, child) {
      return ListTile(
          title: Text(widget.event.title),
          subtitle: Text(
            "Par ${widget.event.nameCreator}",
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              builder.removeHistory(widget.event);
            },
          ),
          onTap: () async {
            var messages = await builder.getMessages(widget.event.id);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EventDetailsPage(event: widget.event, messages: messages),
            ));
          });
    });
  }
}
