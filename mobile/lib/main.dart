import 'package:reunionou/reunionou_app.dart';
import 'package:reunionou/provider/events_provider.dart';
import 'package:reunionou/provider/auth_provider.dart';
import 'package:reunionou/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  // await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  // hide the bottom bar on android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL']!,
  //   anonKey: dotenv.env['SUPABASE_API_KEY']!,
  // );


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
            create: (_) => EventsProvider(null),
            update: (context, auth, prev) => EventsProvider(auth)),
        
      ],
      child: const ReunionouApp(),
    ),
  );
}
