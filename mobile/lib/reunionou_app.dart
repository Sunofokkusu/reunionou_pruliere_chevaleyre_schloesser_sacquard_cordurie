import 'package:flutter/material.dart';
import 'package:reunionou/screens/auth_wrapper.dart';

/// Classe principale de l'application
class ReunionouApp extends StatefulWidget {
  const ReunionouApp({super.key});

  @override
  State<ReunionouApp> createState() => _ReunionouAppState();
}

/// Classe d'état de l'application
class _ReunionouAppState extends State<ReunionouApp> {
  /// Couleurs de l'application
  final lightColor = const Color.fromARGB(255, 221, 96, 255);
  final darkColor = const Color.fromARGB(255, 140, 24, 172);

  /// Méthode de création de l'application, fourni des paramètres d'app et de thèmes
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reunionou',
      debugShowCheckedModeBanner: false,
      home: const AuthenticationWrapper(),
      theme: ThemeData(
        fontFamily: 'SairaCondensed',
        colorScheme: ColorScheme.light(
          primary: lightColor,
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: darkColor,
            centerTitle: true,
            titleTextStyle: const TextStyle(
                fontSize: 30,
                fontFamily: 'SairaCondensedBold',
                color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColor,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
