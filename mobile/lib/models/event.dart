class Event {
  Event({
    required this.id,
    required this.idCreator,
    required this.title,
    required this.desc,
    required this.long,
    required this.lat,
    required this.adress,
    required this.datetime,
  });

  final String id;
  final String idCreator;
  String title;
  String desc;
  double long;
  double lat;
  String adress;
  DateTime datetime;
}
