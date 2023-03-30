import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/event_preview.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_form_page.dart';
import 'package:uuid/uuid.dart';

import 'package:reunionou/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EventsProvider>(builder: (context, events, child) {
        return FutureBuilder<List<Event>>(
            future: events.getEvents(_selectedIndex),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Participant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering),
            label: 'Créateur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Invitations',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
