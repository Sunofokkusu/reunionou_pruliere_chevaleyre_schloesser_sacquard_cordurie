class Comment {
  Comment({
    required this.id,
    required this.idEvent,
    required this.idUser,
    required this.name,
    required this.comment,
    required this.createdAt,
  });

  String id;
  String idEvent;
  String idUser;
  String name;
  String comment = "";
  DateTime createdAt;

  static Comment fromJson(data) {
    return Comment(
      id: data['id'],
      idEvent: data['id_event'],
      idUser: data['id_user'],
      name: data['name'],
      comment: data['comment'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
