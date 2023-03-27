import 'package:flutter/material.dart';
import 'package:reunionou/screens/home.dart';

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
        home: const Home(),
        theme: ThemeData(fontFamily: 'SairaCondensed'));
  }
}
