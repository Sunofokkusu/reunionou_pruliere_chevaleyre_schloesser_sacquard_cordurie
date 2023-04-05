import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reunionou/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe de gestion des événements dans le local storage et sur l'API
class EventsProvider with ChangeNotifier {
  /// Provider d'authentification pour récupérer le token
  final AuthProvider? _authProvider;
  get authProvider => _authProvider;

  /// Storage local
  SharedPreferences? _storage;

  /// Listes des événements invités et créés, historique de recherche, liste des commentaires d'un événement
  List<Event> _eventsInvited = [];
  List<Event> _eventsCreator = [];
  List<Event> _searchHistory = [];
  List<Comment> _comments = [];

  /// Booléens de vérification d'initialisation, actions à effectuer une seule fois
  bool _initInvited = false;
  bool _initCreator = false;
  bool _initStorage = false;

  /// Constructeur contenant le provider d'authentification
  EventsProvider(this._authProvider);

  /// Méthode d'initialisation du storage local
  Future<bool> init() async {
    _storage ??= await SharedPreferences.getInstance();
    return true;
  }

  /// Méthode de récupération de l'historique de recherche
  Future<List<Event>> getHistory() async {
    // Si le storage n'est pas initialisé, on l'initialise et on récupère les événements
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
    // On trie les événements par date de recherche (plus récent en premier)
    _searchHistory
        .sort((a, b) => b.searchTimeStamp!.compareTo(a.searchTimeStamp!));
    return _searchHistory;
  }

  /// Méthode de suppression d'un événement de l'historique de recherche
  Future<bool> removeFromHistory(Event event) async {
    // Si l'événement est dans l'historique, on le supprime et on met à jour le storage
    if (_searchHistory.remove(event)) {
      _storage!.setString('searchHistory', Event.encode(_searchHistory));
      // On notifie les listeners pour mettre à jour l'historique
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Méthode de recherche d'un événement par son id
  Future<Event?> submitSearch(String search) async {
    // Si on fourni le lien complet, on récupère juste l'id
    if (search.contains("event")) {
      search = search.split("/").last;
    }
    // On récupère l'événement
    final event = await getEventById(search);
    // Si l'événement existe
    if (event != null) {
      // Si il est déjà dans l'historique, on le supprime de l'historique
      if (_searchHistory.any((element) => element.id == event.id)) {
        _searchHistory.removeWhere((element) => element.id == event.id);
      }
      // Sinon, si il doit être ajouté à l'historique si l'historique est plein, on supprime le plus ancien
      else if (_searchHistory.length >= 5) {
        _searchHistory.removeLast();
      }
      // On ajoute l'événement à l'historique avec la nouvelle date de recherche et on met à jour le storage local
      event.searchTimeStamp = DateTime.now().millisecondsSinceEpoch;
      _searchHistory.add(event);
      final String encodedData = Event.encode(_searchHistory);
      await _storage!.setString('searchHistory', encodedData);
      // On notifie les listeners pour mettre à jour l'historique et on retourne l'événement
      notifyListeners();
      return event;
    }
    return null;
  }

  /// Méthode de création d'un événement
  Future<String> createEvent(String? title, String? description, String? date,
      String? adress, double? lat, double? long) async {
    // On envoie la requête à l'API
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
    // Si la requête est un succès, on ajoute l'événement à la liste des événements créés
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

    }
    // On notifie les listeners pour mettre à jour les événements créés et on retourne l'id du nouvel événement
    notifyListeners();
    return jsonDecode(response.body)['id'];
  }

  /// Méthode de récupération des événements invités et créés
  Future<List<Event>> getEvents(int index) async {
    // Si l'utilisateur est connecté
    if (_authProvider!.isLoggedIn) {
      // Si on veut récupérer les événements invités
      if (index == 0) {
        if (_initInvited == false) {
          await fetchEvents(index);
          _initInvited = true;
        } else {
          // On trie les événements par date (plus grande date en premier)
          _eventsInvited.sort((a, b) => b.datetime.compareTo(a.datetime));
          return _eventsInvited;
        }
      }
      // Si on veut récupérer les événements créés
      else if (index == 1) {
        if (_initCreator == false) {
          await fetchEvents(index);
          _initCreator = true;
        } else {
          // On trie les événements par date (plus lointain en premier)
          _eventsInvited.sort((a, b) => b.datetime.compareTo(a.datetime));
          return _eventsCreator;
        }
      }
    }
    return [];
  }

  /// Méthode de récupération des événements invités et créés par requête à l'API (sous méthode de getEvents)
  Future<void> fetchEvents(int index) async {
    // On détermine la fin de l'url en fonction de l'index
    var urlEnd = "";
    if (index == 0) {
      urlEnd += "invited";
    } else if (index == 1) {
      urlEnd += "events";
    }
    // On envoie la requête à l'API
    final response = await http.get(
        Uri.parse("${dotenv.env["BASE_URL"]!}/user/me?embed=$urlEnd"),
        headers: <String, String>{
          'Authorization': 'Bearer ${_authProvider!.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        });
    // Si la requête est un succès, on ajoute les événements à la liste correspondante
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data[urlEnd] as List;
      if (index == 0) {
        _eventsInvited = events.map((e) => Event.fromJson(e)).toList();
      } else if (index == 1) {
        _eventsCreator = events.map((e) => Event.fromJson(e)).toList();
      }
    }
    // On notifie les listeners pour mettre à jour les événements invités et créés
    notifyListeners();
  }

  /// Méthode de récupération d'un événement par son id
  Future<Event?> getEventById(String id) async {
    // On envoie la requête à l'API
    final response = await http.get(
        Uri.parse("${dotenv.env["BASE_URL"]!}/event/$id"),
        headers: <String, String>{
          'Authorization': 'Bearer ${_authProvider!.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        });
    // Si la requête est un succès, on retourne l'événement
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Event.fromJson(data);
    }
    return null;
  }

  // Méthode de récupération des commentaires d'un événement
  // Cette méthode retourne une liste de commentaires
  // Elle prend en paramètre l'id de l'événement
  Future<List<Comment>> getComments(String id) async {
    bool exist =
        false; // Booléen pour savoir si l'événement existe dans une des listes d'événements
    if (_eventsCreator.any((element) => element.id == id)) {
      // Si l'événement existe dans la liste des événements créés
      exist = true;
    } else if (_eventsInvited.any((element) => element.id == id)) {
      // Si l'événement existe dans la liste des événements invités
      exist = true;
    } else if (_searchHistory.any((element) => element.id == id)) {
      // Si l'événement existe dans la liste des événements recherchés
      exist = true;
    }
    if (exist) {
      // Si l'événement existe dans une des listes d'événements
      final response = await http.get(
          // requête GET à l'API Event sur la route /event/{id}
          Uri.parse("${dotenv.env["BASE_URL"]!}/event/$id"),
          headers: <String, String>{
            // On envoie le token dans le header de la requête
            'Authorization': 'Bearer ${_authProvider!.token}',
          });
      if (response.statusCode == 200) {
        // Si la requête est un succès
        final data =
            jsonDecode(response.body); // On récupère les données de la réponse
        final list = data['comments']
            as List; // On fait une liste avec la clé 'comments' de la réponse
        _comments = list
            .map((e) => Comment.fromJson(e))
            .toList(); // On formate la liste en une liste de Comment
        _comments.sort((a, b) => b.createdAt
            .compareTo(a.createdAt)); // On trie la liste par date de création
      }
    }
    return _comments; // On retourne la liste de commentaires
  }

  // Méthode d'envoi d'un commentaire
  // Cette méthode retourne un booléen
  // Elle prend en paramètre l'id de l'événement et le commentaire
  Future<bool> postComment(String idEvent, String comment) async {
    bool posted = false; // Booléen pour savoir si le commentaire a été posté
    final response = await http.post(
      // requête POST à l'API Event sur la route /event/{id}/comment
      Uri.parse("${dotenv.env["BASE_URL"]!}/event/$idEvent/comment/"),
      headers: <String, String>{
        // On envoie le token dans le header de la requête
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type':
            'application/json; charset=UTF-8', // On précise le type de contenu
      },
      body: jsonEncode(<String, String>{
        // On envoie le commentaire dans le body de la requête
        'message': comment,
      }),
    );
    if (response.statusCode == 200) {
      // Si la requête est un succès
      posted = true; // On met le booléen à true
    }
    notifyListeners(); // On notifie les listeners pour mettre à jour la liste de commentaires
    return posted; // On retourne le booléen
  }

  /// Méthode de récupération des messages de participation d'un événement par son id
  Future<List<Message>> getMessages(String id) async {
    // On envoie la requête à l'API
    var response = await http
        .get(Uri.parse("${dotenv.env['BASE_URL']}/event/$id/participant"));
    // Si la requête est un succès, on retourne les messages de participation en liste de Message
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Message> messages = [];
      for (var message in data) {
        messages.add(Message.fromJson(message));
      }
      // On notifie les listeners pour mettre à jour les messages de participation de l'événement
      notifyListeners();
      return messages;
    } else {
      return [];
    }
  }

  /// Méthode de création d'un message de participation pour un événement par son id
  Future<bool> postMessage(Event event, String message, int status) async {
    bool posted = false;
    // On envoie la requête à l'API
    final response = await http.post(
      Uri.parse("${dotenv.env["BASE_URL"]!}/event/${event.id}/participant/"),
      headers: <String, String>{
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Le status est 0 pour 'en attente', 1 pour une confirmation et 2 pour un refus
      body: jsonEncode(<String, dynamic>{
        'status': status,
        'message': message,
      }),
    );
    // Si la requête est un succès, on ajoute l'événement à la liste des événements invités
    if (response.statusCode == 200) {
      posted = true;
      _eventsInvited.add(event);
    }
    return posted;
  }

  // Méthode de mise à jour d'un événement
  // Cette méthode retourne un booléen
  // Elle prend en paramètre un événement
  Future<bool> updateEvent(Event event) async {
    bool updated = false; // Booléen pour savoir si l'événement a été mis à jour
    final response = await http.put(
      // requête PUT à l'API Event sur la route /event/
      Uri.parse('${dotenv.env["BASE_URL"]!}/event/'),
      headers: <String, String>{
        // On envoie le token dans le header de la requête
        'Authorization': 'Bearer ${_authProvider!.token}',
        'Content-Type':
            'application/json; charset=UTF-8', // On précise le type de contenu
      },
      body: jsonEncode(<String, String>{
        // On envoie les données de l'événement dans le body de la requête
        'idEvent': event.id,
        'title': event.title,
        'adress': event.adress,
        'description': event.desc,
        'date': event.datetime.toString(), // On convertit la date en String
        'long': event.long.toString(), // On convertit la longitude en String
        'lat': event.lat.toString(), // On convertit la latitude en String
      }),
    );
    if (response.statusCode == 200) {
      // Si la requête est un succès
      updated = true; // On met le booléen à true
    }
    notifyListeners(); // On notifie les listeners pour mettre à jour la liste des événements créés
    return updated; // On retourne le booléen
  }

  // Méthode de suppression d'un événement
  // Cette méthode retourne un booléen
  // Elle prend en paramètre l'id de l'événement à supprimer
  Future<bool> deleteEvent(String id) async {
    bool deleted = false; // Booléen pour savoir si l'événement a été supprimé
    final response = await http.delete(
        // requête DELETE à l'API Event sur la route /event/{id}
        Uri.parse('${dotenv.env["BASE_URL"]!}/event/$id'),
        headers: <String, String>{
          // On envoie le token dans le header de la requête
          'Authorization': 'Bearer ${_authProvider!.token}'
        });
    if (response.statusCode == 200) {
      // Si la requête est un succès
      _eventsCreator.removeWhere((element) =>
          element.id ==
          id); // On supprime l'événement de la liste des événements créés
      deleted = true; // On met le booléen à true
    }
    notifyListeners(); // On notifie les listeners pour mettre à jour la liste des événements créés
    return deleted; // On retourne le booléen
  }
}
