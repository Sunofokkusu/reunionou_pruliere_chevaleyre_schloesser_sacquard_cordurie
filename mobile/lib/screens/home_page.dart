import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/event_preview.dart';
import 'package:reunionou/elements/search_and_history.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_form_page.dart';
import 'package:reunionou/screens/profile_page.dart';

/// Page d'accueil de l'application contenant le bandeau avec logo, bouton de profil et menu d'onglets (invité, créateur, recherche)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Classe d'état de la page d'accueil
class _HomePageState extends State<HomePage> {
  /// Correspond à l'index
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Méthode de création de la page d'accueil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre l'application avec logo, titre, bouton de profil
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
      // Contenu de la page d'accueil
      body: Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
        // Si l'index (commence à 0) est inférieur au nombre d'onglets d'événements (ici 2) on affiche les événements
        if (_selectedIndex <= 1) {
          return FutureBuilder<List<Event>>(
              future: eventsProvider.getEvents(_selectedIndex),
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
                  return const Text(
                      "Les données n'ont pas pu être récupérées.");
                }
                return const Center(child: CircularProgressIndicator());
              });
        }
        // Sinon, si l'index est dépasse le nombre d'onglets d'événements, on affiche le widget de recherche
        else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchAndHistory(),
          );
        }
      }),
      // Dans tout les cas, on affiche le bouton d'ajout d'événement en bas à droite de l'écran
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventFormPage(),
                ),
              ),
          tooltip: 'Ajouter un événement',
          child: const Icon(Icons.add)),
      // Et le menu d'onglets en bas de l'écran
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
