import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/helpers/date_helper.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_details_page.dart';

class EventPreview extends StatefulWidget {
  const EventPreview({super.key, required this.event});

  final Event event;

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

class _EventPreviewState extends State<EventPreview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, builder, child) {
      return ListTile(
          title: Row(
            children: [
              Text(widget.event.title),
              const Spacer(),
              Text(DateHelper.formatDateTime(widget.event.datetime),
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
          subtitle: Text(
            widget.event.desc,
            maxLines: widget.event.desc.isEmpty ? null : 3,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            var messages = await builder.getMessages(widget.event.id);
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
