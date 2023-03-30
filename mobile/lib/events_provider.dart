import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/models/event.dart';

class EventsProvider with ChangeNotifier {
  final AuthProvider? _authProvider;

  List<Event> _eventsMember = [];
  List<Event> _eventsCreator = [];
  List<Event> _eventsInvited = [];

  EventsProvider(this._authProvider) {
    if (_authProvider != null) {
      // TODO: get events
    }
  }

  List<Event> get eventsMember => _eventsMember;
  List<Event> get eventsCreator => _eventsCreator;
  List<Event> get eventsInvited => _eventsInvited;

  Future<bool> createEvent(String? title, String? description, String? date,
      String? adress, double? lat, double? long) async {
    var post = true;
    final response = await http.post(
      Uri.parse('http://localhost:80/event/'),
      headers: <String, String>{
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'date': date,
        'adress': adress,
        'lat': lat,
        'long': long
      }),
    );
    if (response.statusCode == 200) {
      print("coolman coffeDan");
      _eventsCreator.add(Event(
        id: jsonDecode(response.body)['id'],
        idCreator: _authProvider!.user!.id,
        title: title!,
        desc: description!,
        adress: adress!,
        lat: lat!,
        long: long!,
        datetime: DateTime.parse(date!),
      ));
    } else {
      print("VATEFAIREENCULER.COM");
      print(response.statusCode);
      post = false;
    }
    notifyListeners();
    return post;
  }
}
