import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/elements/history_preview.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/event_details_page.dart';

/// Widget de recherche et d'historique
class SearchAndHistory extends StatefulWidget {
  const SearchAndHistory({super.key});

  @override
  _SearchAndHistoryState createState() => _SearchAndHistoryState();
}

/// State du widget de recherche et d'historique
class _SearchAndHistoryState extends State<SearchAndHistory> {
  /// Controller du champ de recherche
  final TextEditingController _searchController = TextEditingController();

  /// Méthode de création de la page de détails d'un événement
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, events, child) {
      return Column(
        children: [
          const SizedBox(height: 16),
          // Champ de recherche
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Entrez l\'url ou le code...',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 16),
          // Bouton de recherche
          ElevatedButton(
            onPressed: () async {
              if (_searchController.text.isEmpty) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez entrer une url ou un code'),
                  ),
                );
                return;
              }
              final event = await events.submitSearch(_searchController.text);
              _searchController.clear();
              if (event == null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aucun événement trouvé'),
                  ),
                );
                return;
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event)),
                );
              }
            },
            child: const Text('Rechercher'),
          ),
          const SizedBox(height: 16),
          // Historique de recherche
          const Text('Historique de recherche :'),
          FutureBuilder<List<Event>>(
            future: events.getHistory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return HistoryPreview(event: snapshot.data![index]);
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      );
    });
  }
}
