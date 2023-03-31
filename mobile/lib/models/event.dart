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

  static Event fromJson(data) {
    return Event(
      id: data['id'],
      idCreator: data['id_creator'],
      nameCreator: data['creator']['name'],
      emailCreator: data['creator']['email'],
      title: data['title'],
      desc: data['description'],
      long: double.parse(data['long'].toString()),
      lat: double.parse(data['lat'].toString()),
      adress: data['adress'],
      datetime: DateTime.parse(data['date']),
    );
  }
}
