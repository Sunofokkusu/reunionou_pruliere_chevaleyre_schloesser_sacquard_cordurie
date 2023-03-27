import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 140, 24, 172),
          centerTitle: true,
          title: const Text(
            "REUNIONOU",
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'SairaCondensedBold',
                color: Colors.white),
          )),
      body: Container(
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
