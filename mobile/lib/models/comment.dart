class Comment {
  Comment({
    required this.id,
    required this.idEvent,
    required this.idUser,
    required this.name,
    required this.comment,
  });

  String id;
  String idEvent;
  String idUser;
  String name;
  String comment = "";
  DateTime createdAt = DateTime.now();

  static Comment fromJson(data) {
    return Comment(
      id: data['id'],
      idEvent: data['id_event'],
      idUser: data['id_user'],
      name: data['name'],
      comment: data['comment'],
    );
  }
}
