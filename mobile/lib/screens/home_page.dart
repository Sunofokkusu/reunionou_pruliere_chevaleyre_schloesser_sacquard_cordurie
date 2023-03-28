import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/event_preview.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_form_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/reunionouIcon.png',
              scale: 6,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'REUNIONOU',
            ),
          ],
        ),
      ),
      body: Consumer<EventsProvider>(builder: (context, builder, child) {
        return FutureBuilder<List<Event>>(
            future: _fetchEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return EventPreview(
                      event: snapshot.data![index],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Text("Les données n'ont pas pu être récupérées.");
              }
              return const Center(child: CircularProgressIndicator());
            });
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventFormPage(),
                ),
              ),
          tooltip: 'Ajouter un événement',
          child: const Icon(Icons.add)),
    );
  }

  Future<List<Event>> _fetchEvents() async {
    return List.generate(15, (index) {
      return Event(
          id: const Uuid().v4(),
          idCreator: const Uuid().v4(),
          title: faker.lorem.words(2).join(" "),
          desc: faker.lorem.sentences(5).join(" "),
          long: faker.randomGenerator.decimal(),
          lat: faker.randomGenerator.decimal(),
          place: faker.address.streetAddress(),
          datetime: faker.date.dateTime(),
          url: faker.internet.httpUrl());
    });
  }
}
