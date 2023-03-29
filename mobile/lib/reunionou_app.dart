import 'package:flutter/material.dart';
import 'package:reunionou/screens/auth_wrapper.dart';

class ReunionouApp extends StatefulWidget {
  const ReunionouApp({super.key});

  @override
  State<ReunionouApp> createState() => _ReunionouAppState();
}

class _ReunionouAppState extends State<ReunionouApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthenticationWrapper(),
      theme: ThemeData(
        fontFamily: 'SairaCondensed',
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 140, 24, 172),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 30,
                fontFamily: 'SairaCondensedBold',
                color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 221, 96, 255),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 221, 96, 255),
        ),
      ),
    );
  }
}
