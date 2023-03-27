import 'package:reunionou/reunionou_app.dart';
import 'package:reunionou/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  // await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL']!,
  //   anonKey: dotenv.env['SUPABASE_API_KEY']!,
  // );

  runApp(
    ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: const ReunionouApp(),
    ),
  );
}
