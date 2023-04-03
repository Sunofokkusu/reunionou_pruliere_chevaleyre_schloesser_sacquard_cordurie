import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsProvider with ChangeNotifier {
  final AuthProvider? _authProvider;
  SharedPreferences? _storage;

  List<Event> _eventsInvited = [];
  List<Event> _eventsCreator = [];
  List<Event> _searchHistory = [];
  List<Comment> _comments = [];

  bool _initInvited = false;
  bool _initCreator = false;
  bool _initStorage = false;

  EventsProvider(this._authProvider);

  List<Event> get eventsInvited => _eventsInvited;
  List<Event> get eventsCreator => _eventsCreator;

  Future<bool> init() async {
    _storage ??= await SharedPreferences.getInstance();
    if (_storage!.getKeys().isEmpty) {
      _storage!.getString('searchHistory');
    }
    if (_storage!.getString('searchHistory') == null) {
      _storage!.getString(
        'searchHistory',
      );
    }
    return true;
  }

  Future<List<Event>> getHistory() async {
    if (!_initStorage) {
      await init();
      _initStorage = true;
      final String? eventsString = _storage!.getString('searchHistory');
      if (eventsString != null) {
        _searchHistory = Event.decode(eventsString);
      } else {
        _searchHistory = [];
      }
    }
    _searchHistory
        .sort((a, b) => b.searchTimeStamp!.compareTo(a.searchTimeStamp!));
    return _searchHistory;
  }

  Future<bool> removeHistory(Event event) async {
    if (_searchHistory.remove(event)) {
      _storage!.setString('searchHistory', Event.encode(_searchHistory));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<Event?> submitSearch(String search) async {
    if (search.contains("event")) {
      search = search.split("/").last;
    }
    final event = await getEventById(search);
    if (event != null) {
      if (_searchHistory.any((element) => element.id == event.id)) {
        _searchHistory.removeWhere((element) => element.id == event.id);
      } else if (_searchHistory.length >= 5) {
        _searchHistory.removeLast();
      }
      event.searchTimeStamp = DateTime.now().millisecondsSinceEpoch;
      _searchHistory.add(event);
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = Event.encode(_searchHistory);
      await prefs.setString('searchHistory', encodedData);
      notifyListeners();
      return event;
    }
    return null;
  }

  Future<String> createEvent(String? title, String? description, String? date,
      String? adress, double? lat, double? long) async {
    final response = await http.post(
      Uri.parse('${dotenv.env["BASE_URL"]!}/event/'),
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
      _eventsCreator.add(Event(
        id: jsonDecode(response.body)['id'],
        idCreator: _authProvider!.user!.id,
        nameCreator: _authProvider!.user!.name,
        emailCreator: _authProvider!.user!.email,
        title: title!,
        desc: description!,
        adress: adress!,
        lat: lat!,
        long: long!,
        datetime: DateTime.parse(date!),
      ));
    } else {
      print(response.statusCode);
    }
    notifyListeners();
    return jsonDecode(response.body)['id'];
  }

  Future<List<Event>> getEvents(int index) async {
    if (_authProvider!.isLoggedIn) {
      if (index == 0) {
        if (_initInvited == false) {
          await fetchEvents(index);
          _initInvited = true;
        } else {
          return _eventsInvited;
        }
      } else if (index == 1) {
        if (_initCreator == false) {
          await fetchEvents(index);
          _initCreator = true;
        } else {
          return _eventsCreator;
        }
      }
    }
    return [];
  }

  Future<void> fetchEvents(int index) async {
    var urlEnd = "";
    if (index == 0) {
      urlEnd += "invited";
    } else if (index == 1) {
      urlEnd += "events";
    }
    await dotenv.load(fileName: "assets/.env");
    final response = await http.get(
      Uri.parse("${dotenv.env["BASE_URL"]!}/user/me?embed=$urlEnd"),
      headers: <String, String>{
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data[urlEnd] as List;
      if (index == 0) {
        _eventsInvited = events.map((e) => Event.fromJson(e)).toList();
      } else if (index == 1) {
        _eventsCreator = events.map((e) => Event.fromJson(e)).toList();
      }
    } else {
      print("et non c'est moi enfait ahaha");
      print(response.statusCode);
    }
    notifyListeners();
  }

  Future<Event?> getEventById(String id) async {
    final response = await http.get(
        Uri.parse("${dotenv.env["BASE_URL"]!}/event/$id"),
        headers: <String, String>{
          'Authorization': 'Bearer ${_authProvider!.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Event.fromJson(data);
    } else {
      print("hihi ct moi depuis le début");
      print(response.statusCode);
    }
    return null;
  }

  Future<List<Comment>> getComments(String id) async {
    bool exist = false;
    if (_eventsCreator.any((element) => element.id == id)) {
      exist = true;
    } else if (_eventsInvited.any((element) => element.id == id)) {
      exist = true;
    }
    if (exist) {
    final response = await http.get(
      Uri.parse("${dotenv.env["BASE_URL"]!}/event/$id"),
      headers: <String, String>{
        'Authorization': 'Bearer ${_authProvider!.token}',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['comments'] as List;
        _comments = list.map((e) => Comment.fromJson(e)).toList();
        _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        print("je compredn pas pk ca marche pas");
        print(response.statusCode);
      }
    }
    return _comments;
  }

  Future<bool> postComment(String idEvent, String comment) async {
    bool posted = false;
    final response = await http.post(
      Uri.parse("${dotenv.env["BASE_URL"]!}/event/$idEvent/comment/"),
      headers: <String, String>{
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': comment,
      }),
    );
    if (response.statusCode == 200) {
      posted = true;
    } else {
      print("fdp");
      print(response.statusCode);
    }
    notifyListeners();
    return posted;
  }

  Future<bool> updateEvent(Event event) async {
    bool updated = false;
    final response = await http.put(
        Uri.parse('${dotenv.env["BASE_URL"]!}/event/'),
        headers: <String, String>{
          'Authorization': 'Bearer ${_authProvider!.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'idEvent': event.id,
          'title': event.title,
          'adress': event.adress,
          'description': event.desc,
          'date': event.datetime.toString(),
          'long': event.long.toString(),
          'lat': event.lat.toString(),
        }),
      );
      if (response.statusCode == 200) {
        updated = true;
      } else {
        print("aled");
        print(response.statusCode);
      }
    notifyListeners();
    return updated;
  }

  Future<bool> deleteEvent(String id) async {
    bool deleted = false;
    final response = await http.delete(
      Uri.parse('${dotenv.env["BASE_URL"]!}/event/$id'),
      headers: <String, String>{
        'Authorization' : 'Bearer ${_authProvider!.token}'
      }
    );
    if (response.statusCode == 200) {
      _eventsCreator.removeWhere((element) => element.id == id);
      deleted = true;
    } else {
      print("c'est moi :D");
      print(response.statusCode);
    }
    notifyListeners();
    return deleted;
  }
}
