import 'package:reunionou/reunionou_app.dart';
import 'package:reunionou/events_provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
            create: (_) => EventsProvider(null),
            update: (context, auth, prev) => EventsProvider(auth)),
      ],
      child: const ReunionouApp(),
    ),
  );
}
