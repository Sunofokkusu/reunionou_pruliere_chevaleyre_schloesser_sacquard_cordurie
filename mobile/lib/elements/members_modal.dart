import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/elements/member_response_tile.dart';
import 'package:reunionou/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reunionou/models/event.dart';

class MembersModal extends StatefulWidget {
  final Event event;

  const MembersModal({Key? key, required this.event}) : super(key: key);

  @override
  _MembersModalState createState() => _MembersModalState();
}

class _MembersModalState extends State<MembersModal> {
  bool _modalOpen = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: screenHeight * 0.8,
        width: screenWidth * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.55,
              child: FutureBuilder<List<Message>>(
                  future: _fetchMessage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return MemberResponseTile(
                            message: snapshot.data![index],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                          "Les données n'ont pas pu être récupérées.");
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            ElevatedButton(
              onPressed: close,
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void close() {
    setState(() {
      _modalOpen = false;
    });
    Navigator.of(context).pop();
  }

  void open() {
    setState(() {
      _modalOpen = true;
    });
  }

  Future<List<Message>> _fetchMessage() async {
    await dotenv.load(fileName: "assets/.env");
    var response = http.get(Uri.parse("${dotenv.env['BASE_URL']}/event/${widget.event.id}/participant"));
    if(response != null) {
      var data = jsonDecode((await response).body);
      List<Message> messages = [];
      for (var message in data) {
        messages.add(Message.fromJson(message));
      }
      return messages;
    }else{
      return [];
    }
  }
}
