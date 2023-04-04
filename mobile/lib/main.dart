import 'package:reunionou/reunionou_app.dart';
import 'package:reunionou/providers/events_provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

/// Méthode principale de l'application
void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();

  // Permet de cacher la barre de statut basse (menu, accueil, retour)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  // Lanceur de l'application
  runApp(
    // Mise en place des providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        // Le provider d'événements est mis à jour à chaque fois que le provider d'authentification est mis à jour et peut faire appel à ses méthodes
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
            create: (_) => EventsProvider(null),
            update: (context, auth, prev) => EventsProvider(auth)),
      ],
      // Application principale
      child: const ReunionouApp(),
    ),
  );
}
