import 'dart:convert';

class Event {
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

  final String id;
  final String idCreator;
  final String nameCreator;
  final String emailCreator;
  String title;
  String desc;
  double long;
  double lat;
  String adress;
  DateTime datetime;
  int? searchTimeStamp;

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

  static String encode(List<Event> events) => json.encode(
        events
            .map<Map<String, dynamic>>((event) => Event.toMap(event))
            .toList(),
      );

  static List<Event> decode(String events) {
    final decoded = json.decode(events);
    return List<Event>.from(
      decoded.map((x) => Event.fromJson(x)),
    );
  }
}
