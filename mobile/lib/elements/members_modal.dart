import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/elements/member_response_tile.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/user.dart';

class MembersModal extends StatefulWidget {
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
            FutureBuilder<List<Comment>>(
                future: _fetchComments(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return MemberResponseTile(
                          comment: snapshot.data![index],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                        "Les données n'ont pas pu être récupérées.");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const Expanded(
              child: SizedBox(),
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

  Future<List<Comment>> _fetchComments() async {
    return List.generate(10, (index) {
      return Comment(
        name: faker.person.name(),
        email: faker.internet.email(),
        text: faker.lorem.words(faker.randomGenerator.integer(2)).join(' '),
        response: faker.randomGenerator.integer(3),
      );
    });
  }
}
