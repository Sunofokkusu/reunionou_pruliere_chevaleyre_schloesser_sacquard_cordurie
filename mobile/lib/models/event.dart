import 'dart:convert';

/// Classe modélisant un événement
class Event {
  /// Constructeur
  Event({
    required this.id,
    required this.idCreator,
    required this.nameCreator,
    required this.emailCreator,
    required this.title,
    required this.desc,
    required this.long,
    required this.lat,
    required this.adress,
    required this.datetime,
    this.searchTimeStamp,
  });

  /// id de l'événement
  final String id;

  /// id de l'utilisateur créateur de l'événement
  final String idCreator;

  /// nom de l'utilisateur créateur de l'événement
  final String nameCreator;

  /// email de l'utilisateur créateur de l'événement
  final String emailCreator;

  /// titre de l'événement
  String title;

  /// description de l'événement
  String desc;

  /// longitude du lieu l'événement
  double long;

  /// latitude du lieu l'événement
  double lat;

  /// adresse du lieu l'événement
  String adress;

  /// date de l'événement
  DateTime datetime;

  /// timestamp de recherche de l'événement, null si l'événement ne se trouve pas dans l'historique de recherche
  int? searchTimeStamp;

  /// Méthode de création d'un événement à partir d'un json
  factory Event.fromJson(Map<String, dynamic> jsonData) {
    return Event(
        id: jsonData['id'],
        idCreator: jsonData['id_creator'],
        nameCreator: jsonData['creator']['name'],
        emailCreator: jsonData['creator']['email'],
        title: jsonData['title'],
        desc: jsonData['description'],
        long: double.parse(jsonData['long'].toString()),
        lat: double.parse(jsonData['lat'].toString()),
        adress: jsonData['adress'],
        datetime: DateTime.parse(jsonData['date']),
        searchTimeStamp: jsonData['searchTimeStamp']);
  }

  /// Méthode de création d'une liste d'événements à partir de json
  static List<Event> decode(String events) {
    final decoded = json.decode(events);
    return List<Event>.from(
      decoded.map((x) => Event.fromJson(x)),
    );
  }

  /// Mise au format json d'un événement
  static Map<String, dynamic> toMap(Event event) => {
        'id': event.id,
        'id_creator': event.idCreator,
        'creator': {
          'name': event.nameCreator,
          'email': event.emailCreator,
        },
        'title': event.title,
        'description': event.desc,
        'long': event.long,
        'lat': event.lat,
        'adress': event.adress,
        'date': event.datetime.toString(),
        'searchTimeStamp': event.searchTimeStamp,
      };

  /// Mise au format json d'une liste d'événements
  static String encode(List<Event> events) => json.encode(
        events
            .map<Map<String, dynamic>>((event) => Event.toMap(event))
            .toList(),
      );

  bool isPast() {
    return datetime.isBefore(DateTime.now());
  }
}
